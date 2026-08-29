package utils.common;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public  class LogsUtils {
   //    https://appium.readthedocs.io/en/latest/en/commands/session/logs/get-log/

    public static final String LOG_FILE_PATH = "test_outputs/logs";
    private static final List<String> logs= Collections.synchronizedList(new ArrayList<>());
    private LogsUtils() {
    }

    private static Logger logger() {
        return LogManager.getLogger(Thread.currentThread().getStackTrace()[3].getClassName());
    }

    private static void record(String message) {
        logs.add(message);
    }

    public static void trace(String... messages) {
        String logMessage = String.join(" ", messages);
        logger().trace(logMessage);
        record("[TRACE] - ["+DateTime.getDateTime()+"] - " + logMessage);
    }

    public static void debug(String... messages) {
        String logMessage = String.join(" ", messages);
        logger().debug(logMessage);
        record("[DEBUG] - ["+DateTime.getDateTime()+"] - " + logMessage);
    }

    public static void info(String... messages) {
        String logMessage = String.join(" ", messages);
        logger().info(logMessage);
        record("[INFO] - ["+DateTime.getDateTime()+"] - "+ logMessage);
    }

    public static void warn(String... messages) {
        String logMessage = String.join(" ", messages);
        logger().warn(logMessage);
        record("[WARN] - ["+DateTime.getDateTime()+"] - "+ logMessage);
    }

    public static void error(String... messages) {
        String logMessage = String.join(" ", messages);
        logger().error(logMessage);
        record("[ERROR] - ["+DateTime.getDateTime()+"] - " + logMessage);
    }

    public static String getCapturedLogs() {
        return String.join("\n", logs);
    }

    public static void clearCapturedLogs() {
        logs.clear();
    }
}
