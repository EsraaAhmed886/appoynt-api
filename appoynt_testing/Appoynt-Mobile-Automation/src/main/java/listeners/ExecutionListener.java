package listeners;

import org.testng.IExecutionListener;
import utils.appium.ServerManager;
import utils.appium.TakeScreenShot;
import utils.appium.TerminalLogsCapture;
import utils.common.AllureUtils;
import utils.common.FilesUtils;
import utils.common.LogsUtils;
import utils.common.SystemProperties;

import java.io.PrintStream;

import static utils.common.AllureUtils.*;

public class ExecutionListener implements IExecutionListener {

    @Override
    public void onExecutionStart() {
        TerminalLogsCapture capture = new TerminalLogsCapture();
        System.setOut(new PrintStream(capture));
        System.setErr(new PrintStream(capture));
        FilesUtils.createDirectoryIfNeeded(LogsUtils.LOG_FILE_PATH);
        FilesUtils.createDirectoryIfNeeded(AllureUtils.Allure_Results_Path);
        FilesUtils.createDirectoryIfNeeded(TakeScreenShot.SCREEN_SHOTS_PATH);
        FilesUtils.createDirectoryIfNeeded(AllureUtils.Allure_Report_Path);
        FilesUtils.deleteFileContent(AllureUtils.Allure_Results_Path,"executor.json");
        FilesUtils.deleteFileContent(TakeScreenShot.SCREEN_SHOTS_PATH);
        SystemProperties.load();
        AllureUtils.setEnvironmentVariables();
        ServerManager.startService();
    }

    @Override
    public void onExecutionFinish() {
        SystemProperties.load();
        String executionType = System.getProperty("executionType", "local");
        if ("local".equalsIgnoreCase(executionType)) {
            createReport();
            openReport(renameReport());
            ServerManager.stopService();
        }
    }
}
