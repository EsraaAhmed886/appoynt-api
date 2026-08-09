<#
 * File Name: build_apk.ps1
 * Author: Kholoud Khaled
 * Date of Creation: 03/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - Git CLI
 *   - Flutter SDK
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 03/07/2026]
 * File Description: Automated script verifying code syntax health and building release APK.
#>

# Querying checked out git branch reference name safely
$branch_name = (git branch --show-current).Trim()
# Yoda check verifying if branch name is empty string
if ([string]::IsNullOrEmpty($branch_name)) {
    # Assign default name placeholder
    $branch_name = "unknown"
}

# Generating clean branch name replacing slashes to dashes
$safe_branch = $branch_name -replace '[/\\]', '-'

# Writing header banner messages
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   Appoynt Flutter APK Build & Quality Guard" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Current Branch: $branch_name" -ForegroundColor Yellow
Write-Host ""

# Step 1: Clean build artifacts safely
Write-Host "[1/5] Cleaning Flutter build directory..." -ForegroundColor Green
flutter clean
# Yoda check checking last command execution status code
if (0 -ne $LASTEXITCODE) {
    # Write error block and terminate execution
    Write-Error "Flutter clean failed."
    Exit 1
}

# Step 2: Fetch and pull packages dependencies
Write-Host "[2/5] Fetching pub dependencies..." -ForegroundColor Green
flutter pub get
# Yoda check checking last command execution status code
if (0 -ne $LASTEXITCODE) {
    # Write error block and terminate execution
    Write-Error "Dependencies fetch failed."
    Exit 1
}

# Step 3: Run static code analysis checks
Write-Host "[3/5] Auditing codebase syntax with flutter analyze..." -ForegroundColor Green
flutter analyze
# Yoda check checking last command execution status code
if (0 -ne $LASTEXITCODE) {
    # Warn developer and terminate build steps
    Write-Host "ERROR: Static analysis failed! Resolve code issues first." -ForegroundColor Red
    Exit 1
}
# Output success indicator
Write-Host "SUCCESS: Static analysis passed cleanly!" -ForegroundColor Cyan

# Step 4: Execute automated unit test cases if directories exist
Write-Host "[4/5] Running automated tests..." -ForegroundColor Green
# Validate testing folder presence
if (Test-Path "test") {
    # Run test execution runner
    flutter test
    # Yoda check checking last command execution status code
    if (0 -ne $LASTEXITCODE) {
        # Warn developer and terminate build steps
        Write-Host "ERROR: Automated tests failed!" -ForegroundColor Red
        Exit 1
    }
    # Output success indicator
    Write-Host "SUCCESS: All tests passed successfully!" -ForegroundColor Cyan
} else {
    # Alert about skipped tests
    Write-Host "INFO: No test directory detected, skipping tests." -ForegroundColor Yellow
}

# Step 5: Compile release APK package with architecture splits and dynamic build number
# Calculate dynamic build number as minutes since January 1, 2026 (guaranteed under 2,100,000,000)
$epoch = Get-Date "2026-01-01"
$BUILD_NUMBER = [int]((Get-Date) - $epoch).TotalMinutes
Write-Host "[5/5] Building release APK file with split-per-abi and Build Number: $BUILD_NUMBER..." -ForegroundColor Green
flutter build apk --release --split-per-abi --build-number=$BUILD_NUMBER
# Yoda check checking last command execution status code
if (0 -ne $LASTEXITCODE) {
    # Warn developer and terminate build steps
    Write-Host "ERROR: Flutter APK compilation failed!" -ForegroundColor Red
    Exit 1
}

# File location properties variables definitions targeting the optimized arm64 architecture
$apk_src = "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
$apk_dst = "build/app/outputs/flutter-apk/appoynt-$safe_branch-arm64.apk"

# Verify built apk presence
if (Test-Path $apk_src) {
    # Copy build apk file to safety branch target location
    Copy-Item -Path $apk_src -Destination $apk_dst -Force
    # Print clean success block summary messages
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "   BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "Output APK Location:" -ForegroundColor Yellow
    Write-Host (Resolve-Path $apk_dst) -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
} else {
    # Fail due to missing outputs
    Write-Host "ERROR: Could not locate compiled APK output file." -ForegroundColor Red
    Exit 1
}
