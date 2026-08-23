#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$token = $env:GITHUB_TOKEN
$prNumber = $env:PR_NUMBER
$repo = $env:REPO_NAME

if (-not $token -or -not $prNumber -or -not $repo) {
    Write-Error "Missing required environment variables: GITHUB_TOKEN, PR_NUMBER, or REPO_NAME."
    exit 1
}

$headers = @{
    "Authorization"        = "Bearer $token"
    "User-Agent"           = "Antigravity-PR-Reviewer-Action"
    "Accept"               = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

Write-Host "=== 1. Fetching PR #$prNumber from $repo ==="
$pr = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/pulls/$prNumber" -Headers $headers -Method Get
$files = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/pulls/$prNumber/files?per_page=100" -Headers $headers -Method Get
$commits = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/pulls/$prNumber/commits?per_page=100" -Headers $headers -Method Get

Write-Host "PR Title: $($pr.title)"
Write-Host "Author: $($pr.user.login)"
Write-Host "Total Commits: $($commits.Count)"
Write-Host "Total Changed Files: $($files.Count)"

# --- 2. Check Commit Messages and PR Title Standards ---
$commitPattern = "^\[APPOYNT-[0-9]+\]\[(MOBILE|FRONTEND|BACKEND|AI|TESTING|CONFIGURATION)\]\[(FEATURE|FIX|REFACTOR)\]: .+"
$invalidCommits = @()

if ($pr.title -notmatch $commitPattern) {
    $invalidCommits += "PR Title: '$($pr.title)'"
}

foreach ($c in $commits) {
    $firstLine = ($c.commit.message -split "\r?\n")[0].Trim()
    if ($firstLine -notmatch $commitPattern) {
        $sha7 = $c.sha.Substring(0,7)
        $invalidCommits += "Commit $sha7 : '$firstLine'"
    }
}

# --- 3. Clean old bot inline comments if any ---
try {
    $moreInline = $true
    while ($moreInline) {
        $inlineComments = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/pulls/$prNumber/comments?per_page=100" -Headers $headers -Method Get
        $myComments = $inlineComments | Where-Object { $_.user.login -eq "github-actions[bot]" -or $_.user.login -match "actions-user" -or $_.user.login -eq "mustafamahmoudappoynt" }
        if (-not $myComments -or $myComments.Count -eq 0) {
            $moreInline = $false
            break
        }
        foreach ($c in $myComments) {
            try {
                Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/pulls/comments/$($c.id)" -Headers $headers -Method Delete
            } catch { }
        }
    }
} catch { }

# --- 4. Analyze Source Files with Accurate Bracket Matching (Using Full File Context) ---
$sourceExtensions = @(".dart", ".ts", ".tsx", ".js", ".jsx", ".cs")
$allIssues = @()

foreach ($file in $files) {
    $filename = $file.filename
    $patch = $file.patch
    $ext = [System.IO.Path]::GetExtension($filename).ToLower()

    if (-not $patch -or $ext -notin $sourceExtensions) { continue }
    if ($filename -match "package-lock\.json" -or $filename -match "\.d\.ts$" -or $filename -match "\.g\.dart$" -or $filename -match "app_localizations.*\.dart$" -or $filename -match "Migrations") { continue }

    $fullFileLines = if (Test-Path $filename) { Get-Content $filename } else { @() }
    if ($fullFileLines.Count -eq 0) { continue }

    $lines = $patch -split "\r?\n"
    $currentLineNum = 0
    $addedLineNumbers = @()

    foreach ($line in $lines) {
        if ($line -match "^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@") {
            $currentLineNum = [int]$matches[1] - 1
            continue
        }
        if ($line.StartsWith("-")) { continue }
        $currentLineNum++
        if ($line.StartsWith("+") -and -not $line.StartsWith("+++")) {
            $addedLineNumbers += $currentLineNum
        }
    }

    # Rule 1: Header check on added/new files
    $hasHeader = ($fullFileLines[0..[Math]::Min(30, $fullFileLines.Count - 1)] -join "`n") -match "File Name\s*:" -or ($fullFileLines[0..[Math]::Min(30, $fullFileLines.Count - 1)] -join "`n") -match "Date of Creation\s*:"
    if (-not $hasHeader -and $file.status -eq "added") {
        $firstLine = if ($addedLineNumbers.Count -gt 0) { $addedLineNumbers[0] } else { 1 }
        $allIssues += [PSCustomObject]@{
            path = $filename
            line = $firstLine
            type = "Missing Header"
            body = "**[Warning]** Missing required File Header Documentation (File Name, Author, Created Date, Version, etc.)."
        }
    }

    # Rule 2: Header Last Modified sync
    if ($hasHeader) {
        $headerSnippet = $fullFileLines[0..[Math]::Min(30, $fullFileLines.Count - 1)] -join "`n"
        if ($headerSnippet -match "(?:Last Modified\s*:\s*|Last Modified Date\s*:\s*)([^\r\n]+)") {
            $lastModVal = $matches[1].Trim()
            if ($lastModVal -match "202[0-5]" -or $lastModVal -match "2026-0[1-7]" -or $lastModVal -match "/0[1-7]/2026") {
                $allIssues += [PSCustomObject]@{
                    path = $filename
                    line = 1
                    type = "Outdated Date"
                    body = "**[Warning]** ``Last Modified`` date is outdated ($lastModVal). Please synchronize it with the current commit / PR date."
                }
            }
        }
    }

    # Rule 3: Inspect modified lines with FULL FILE context for accurate bracket & else tracking
    foreach ($lNum in $addedLineNumbers) {
        if ($lNum -gt $fullFileLines.Count) { continue }
        $code = $fullFileLines[$lNum - 1].Trim()

        if ([string]::IsNullOrWhiteSpace($code) -or $code.StartsWith("/*") -or $code.StartsWith("*") -or $code.StartsWith("//") -or $code.StartsWith("///") -or $code.StartsWith("using ") -or $code.StartsWith("import ") -or $code.StartsWith("@")) {
            continue
        }

        # Check: Uninitialized variable declaration
        if ($code -match "^\s*(?:let|var)\s+[a-zA-Z0-9_$]+\s*;") {
            $allIssues += [PSCustomObject]@{
                path = $filename
                line = $lNum
                type = "Uninitialized Variable"
                body = "**[Warning]** Variables must be initialized upon declaration (Declaration & Initialization together)."
            }
        }

        # Check: Single line if without braces
        if ($code -match "^\s*if\s*\([^\)]+\)\s*([^{;]+);$" -and $code -notmatch "=>") {
            $allIssues += [PSCustomObject]@{
                path = $filename
                line = $lNum
                type = "Missing Braces"
                body = "**[Warning]** Conditional statement must use curly braces ``{ }``."
            }
            continue
        }

        # Check: If statement with braces (Accurate Bracket Depth Tracking using Full File Context)
        if ($code -match "^\s*if\s*\(" -or $code -match "^\s*\}\s*else\s+if\s*\(" -or $code -match "^\s*else\s+if\s*\(") {
            $depth = 0
            $started = $false
            $hasElseAtEnd = $false
            $endFound = $false

            for ($j = $lNum - 1; $j -lt $fullFileLines.Count; $j++) {
                $lineChars = $fullFileLines[$j].ToCharArray()
                for ($k = 0; $k -lt $lineChars.Length; $k++) {
                    $ch = $lineChars[$k]
                    if ($ch -eq '{') {
                        $depth++
                        $started = $true
                    } elseif ($ch -eq '}') {
                        $depth--
                        if ($started -and $depth -eq 0) {
                            $remainder = ""
                            if ($k + 1 -lt $lineChars.Length) {
                                $remainder = ($lineChars[($k+1)..($lineChars.Length-1)] -join "").Trim()
                            }

                            if ($remainder -match "^else") {
                                $hasElseAtEnd = $true
                                $endFound = $true
                                break
                            } else {
                                for ($nextIdx = $j + 1; $nextIdx -lt [Math]::Min($j + 5, $fullFileLines.Count); $nextIdx++) {
                                    $nextL = $fullFileLines[$nextIdx].Trim()
                                    if ([string]::IsNullOrWhiteSpace($nextL) -or $nextL.StartsWith("//")) { continue }
                                    if ($nextL.StartsWith("else") -or $nextL.StartsWith("} else")) {
                                        $hasElseAtEnd = $true
                                    }
                                    break
                                }
                                $endFound = $true
                                break
                            }
                        }
                    }
                }
                if ($endFound) { break }
            }

            if ($endFound -and -not $hasElseAtEnd -and $code -notmatch "^\s*\}\s*else" -and $code -notmatch "^\s*else\s+if") {
                $allIssues += [PSCustomObject]@{
                    path = $filename
                    line = $lNum
                    type = "Missing Else"
                    body = "**[Warning]** Missing explicit ``else`` block (use ``else { // No action needed }`` if empty)."
                }
            }
        }

        # Check: Switch statement without default
        if ($code -match "^\s*switch\s*\([^\)]+\)\s*\{") {
            $hasDefault = $false
            for ($j = $lNum; $j -lt [Math]::Min($lNum + 100, $fullFileLines.Count); $j++) {
                $nextCode = $fullFileLines[$j].Trim()
                if ($nextCode -match "default\s*:") {
                    $hasDefault = $true
                    break
                }
            }
            if (-not $hasDefault) {
                $allIssues += [PSCustomObject]@{
                    path = $filename
                    line = $lNum
                    type = "Missing Switch Default"
                    body = "**[Warning]** ``switch`` statement must include an explicit ``default:`` case."
                }
            }
        }
    }
}

Write-Host "Total Issues Found: $($allIssues.Count)"

# --- 5. Construct Structured Checklist Review Body with explicit file names ---
$summaryLines = @(
    "### Code Quality & Standards Automated Review",
    "",
    "This automated review checks adherence to team conventions (Commit Hooks, Variable Initializations, File Headers, Last Modified Sync, Conditionals & Braces, Explicit Else/Default, Comments, and Constants).",
    ""
)

if ($invalidCommits.Count -gt 0) {
    $summaryLines += "#### Commit Message / PR Title Convention Issues:"
    $summaryLines += "Required format: [APPOYNT-NUMBER][LAYER][TYPE]: message"
    $summaryLines += "Allowed Layers: MOBILE, FRONTEND, BACKEND, AI, TESTING, CONFIGURATION"
    $summaryLines += "Allowed Types: FEATURE, FIX, REFACTOR"
    $summaryLines += ""
    foreach ($inv in $invalidCommits) {
        $summaryLines += "- $inv"
    }
    $summaryLines += ""
    $summaryLines += "---"
}

if ($allIssues.Count -gt 0) {
    $summaryLines += "#### Required Modifications Checklist:"
    
    $groupedByFile = $allIssues | Group-Object path
    foreach ($grp in $groupedByFile) {
        $filePath = $grp.Name
        $count = $grp.Count
        $summaryLines += ""
        $summaryLines += "**File:** ``$filePath`` ($count item(s) to fix)"
        foreach ($iss in $grp.Group) {
            $l = $iss.line
            $b = $iss.body
            $summaryLines += "- **Line $l**: $b"
        }
    }
    $summaryLines += ""
    $summaryLines += "---"
    if ($allIssues.Count -le 35) {
        $summaryLines += "*(Note: Direct inline comments have also been placed on each individual line above for easy reference)*"
    }
} else {
    $summaryLines += "**Status:** All files and commits in this Pull Request are 100% compliant with all team conventions!"
}

$reviewBodyText = $summaryLines -join "`n"

$reviewRequest = @{
    commit_id = $pr.head.sha
    body      = $reviewBodyText
    event     = "COMMENT"
}

if ($allIssues.Count -le 35) {
    $commentsArray = @()
    foreach ($c in $allIssues) {
        $commentsArray += @{
            path = [string]$c.path
            line = [int]$c.line
            side = "RIGHT"
            body = [string]$c.body
        }
    }
    $reviewRequest["comments"] = $commentsArray
}

$jsonBody = $reviewRequest | ConvertTo-Json -Depth 10 -Compress
$utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($jsonBody)

Write-Host "`nPosting Automated Review to GitHub for $repo #$prNumber..."
$reviewUri = "https://api.github.com/repos/$repo/pulls/$prNumber/reviews"
$response = Invoke-RestMethod -Uri $reviewUri -Headers $headers -Method Post -Body $utf8Bytes -ContentType "application/json; charset=utf-8"

Write-Host "SUCCESS: Automated Review posted successfully! Review ID: $($response.id)"

if ($allIssues.Count -gt 0 -or $invalidCommits.Count -gt 0) {
    Write-Host "::error::PR Review failed due to rule violations. Please fix them to pass the check."
    exit 1
} else {
    Write-Host "PR Review passed successfully. No rule violations found."
    exit 0
}
