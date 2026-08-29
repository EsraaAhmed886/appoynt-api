package utils.appium;


import utils.common.LogsUtils;

import java.io.OutputStream;
import java.io.PrintStream;

public class TerminalLogsCapture extends PrintStream {

    public TerminalLogsCapture() {
        super(new OutputStream() {
            private final StringBuffer buffer = new StringBuffer();
            @Override
            public synchronized void write(int b) {
                if (b == '\n') {
                    String logLine = buffer.toString().trim();
                    if (!logLine.isEmpty()) {
                       log(logLine);
                    }
                    buffer.setLength(0);
                } else {
                    buffer.append((char) b);
                }
            }
            private void log(String logLine) {
                String firstWord = logLine.split("\\s+")[0].replaceAll("[\\[\\]:]", "").toLowerCase();
                switch (firstWord) {
                    case "error" -> LogsUtils.error(logLine);
                    case "warn", "warning" -> LogsUtils.warn(logLine);
                    case "debug" -> LogsUtils.debug(logLine);
                    case "trace" -> LogsUtils.trace(logLine);
                    default -> LogsUtils.info(logLine);
                }
            }
        }, true);
    }
}

