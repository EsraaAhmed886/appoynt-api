package utils.common;

import io.qameta.allure.Allure;
import org.testng.ITestResult;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;

import static java.util.Objects.isNull;


public class AllureUtils {
    public static final String Allure_Results_Path = "test_outputs/allure_results";
    public static final String Allure_Report_Path = "test_outputs/allure_report";


    public static void attachLogs(ITestResult result) {
        String testName= result.getMethod().getMethodName();
        String logs = LogsUtils.getCapturedLogs();
        LogsUtils.info("Attaching logs for test: " + testName);
        if (!logs.isEmpty()) {
            Allure.addAttachment(testName + " Logs", logs);
            LogsUtils.info("Logs attached successfully for test: " + testName);
        }else {
            LogsUtils.error("No logs captured for test: " + testName);
        }
        LogsUtils.clearCapturedLogs();
    }

    public static void attachPng(File file) {
        try (InputStream is = new FileInputStream(file)) {
            Allure.addAttachment(
                    file.getName(),
                    "image/png",
                    is,
                    ".png"
            );
            LogsUtils.info("Screenshot attached successfully: " + file.getName());
        } catch (IOException e) {
            LogsUtils.error("Failed to attach screenshot: " + file.getName() + ". Error: " + e.getMessage() );
        }
    }
    public static void createReport(){
        boolean successful= TerminalUtils.executeCommand(true,"allure", "generate",Allure_Results_Path, "-o", Allure_Report_Path, "--clean" ,"--single-file");
        if (!successful) {
            LogsUtils.error("Failed to generate allure report");
            return;
        }
        LogsUtils.info("Allure report generated successfully");
    }

    public static void openReport(Path file){

        if ( isNull(file) ) {
            LogsUtils.warn("No allure report found in: " + Allure_Report_Path);
        }
        else {
            Path absolutePath = file.toAbsolutePath();
            LogsUtils.info("Opening allure report: " + absolutePath);
            if(System.getProperty("os.name").toLowerCase().contains("win") ){
                TerminalUtils.executeCommand(false,"start","\"\"",String.format("\"%s\"",absolutePath));
            } else {
                TerminalUtils.executeCommand(false,"open",String.format("\"%s\"",absolutePath));
            }
        }
    }

    public static Path renameReport(){
        Path file = FilesUtils.getLatestFile(Allure_Report_Path);
        if (isNull(file)) {
            LogsUtils.warn("No allure report found in: " + Allure_Report_Path);
            return null;
        }
        Path newFile = Path.of(Allure_Report_Path, "Report "+DateTime.getDateTime()+".html");
        FilesUtils.renameFile(file,newFile);
        LogsUtils.info("Allure report renamed successfully to: " + newFile);
        return newFile;
    }


    public static void setEnvironmentVariables () {
        try {
            Files.write(Paths.get(Allure_Results_Path+"/environment.properties"),
                    Arrays.asList("Environment= "+System.getProperty("environmentType"),"AUT= "+System.getProperty("appTitle")));
        } catch (Exception e) {
            LogsUtils.error("Failed to set environment properties: " + e.getMessage());
        }
    }

}
