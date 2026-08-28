package utils.common;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;
import java.util.Map;


public class JsonUtils {
    private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

    public static Object readJson(String path) {
        LogsUtils.info("Reading JSON file from path: " + path);
        try {
            Path filePath = Paths.get(path);
            JsonNode root = JSON_MAPPER.readTree(filePath.toFile());
            if (root.isArray()) {
                if (root.get(0).isArray()) {
                    List<List<Object>> data = JSON_MAPPER.convertValue(root, new TypeReference<List<List<Object>>>() {});
                    LogsUtils.info("Successfully read JSON Array of Arrays from: " + path);
                    return data;
                }
                else {
                    List<Map<String, Object>> data = JSON_MAPPER.convertValue(root, new TypeReference<List<Map<String, Object>>>() {});
                    LogsUtils.info("Successfully read JSON Array from: " + path);
                    return data;
                }
            }
            else if (root.isObject()) {
                Map<String, Object> data = JSON_MAPPER.convertValue(root, new TypeReference<Map<String, Object>>() {});
                LogsUtils.info("Successfully read JSON Object from: " + path);
                return data;
            }
            else {
                LogsUtils.error("Unknown JSON structure at: " + path);
                return Collections.emptyMap();
            }
        } catch (IOException e) {
            LogsUtils.error("Failed to read JSON file: " + path + ". Error: " + e.getMessage());
            return Collections.emptyMap();
        }
    }


    public static <T> T readJson(String path, Class<T> clazz) {
        LogsUtils.info("Reading JSON file from path: " + path);
        try {
            Path filePath = Paths.get(path);
            T data = JSON_MAPPER.readValue(filePath.toFile(), clazz);
            LogsUtils.info("Successfully deserialized JSON to: " + clazz.getSimpleName());
            return data;
        } catch (IOException e) {
            LogsUtils.error("Failed to read JSON file: " + path + ". Error: " + e.getMessage());
            return null;
        }
    }


    public static void writeJson(String path, Object data) {
        LogsUtils.info("Writing JSON data to path: " + path);
        try {
            JSON_MAPPER.writerWithDefaultPrettyPrinter()
                    .writeValue(Paths.get(path).toFile(), data);
            LogsUtils.info("Successfully wrote JSON data to: " + path);
        } catch (IOException e) {
            LogsUtils.error("Failed to write JSON file: " + path + ". Error: " + e.getMessage());
        }
    }

}
