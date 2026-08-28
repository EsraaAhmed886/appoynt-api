package utils.common;

import java.util.ArrayList;
import java.util.List;


public class TerminalUtils {
    private static final List<Process> runningProcesses = new ArrayList<>();

    public static boolean executeCommand(boolean wait, String... command) {
        LogsUtils.info("Executing command: " + String.join(" ", command));
        boolean success;
        try {
            String os = System.getProperty("os.name").toLowerCase();
            ProcessBuilder processBuilder;
            if (os.contains("win")) {
                processBuilder = new ProcessBuilder("cmd.exe", "/c", String.join(" ", command));
            } else {
                processBuilder = new ProcessBuilder("/bin/bash", "-c", String.join(" ", command));
            }
            processBuilder.inheritIO();
            Process process = processBuilder.start();
            if (wait) {
               success= process.waitFor()==0;
            }else {
                runningProcesses.add(process);
                success=true;
            }
            LogsUtils.info("Command executed: " + String.join(" ", command));
            return success;
        } catch (Exception e) {
            LogsUtils.error("Failed to execute command: " + String.join(" ", command) + ". Error: " + e.getMessage());
            return false;
        }
    }

    public static boolean executeCommand(String... command) {
        return executeCommand(false, command);
    }


    public static void killAllRunningProcesses() {
        LogsUtils.info("Killing all running processes.");
        for (Process process : runningProcesses) {
            process.destroy();
        }
        runningProcesses.clear();
        LogsUtils.info("All running processes killed successfully.");
    }
}
