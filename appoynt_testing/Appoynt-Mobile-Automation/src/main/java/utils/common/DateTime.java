package utils.common;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTime {

    public static String getDate(String format) {
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        return formatter.format(date);
    }

    public static String getDate() {
        String format= "yyyy-MM-dd";
        return getDate(format);
    }

    public static String getTime(String format) {
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        return formatter.format(date);
    }

    public static String getTime() {
        String format= "HH-mm-ss";
        return getTime(format);
    }

    public static String getDateTime(String format) {
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        return formatter.format(date);
    }

    public static String getDateTime() {
        String format= "yyyy-MM-dd HH-mm-ss";
        return getDateTime(format);
    }
}
