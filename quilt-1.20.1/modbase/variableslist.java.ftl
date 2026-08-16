public class @JavaModNameVariables {
    // Variable storage for this mod
    private static final Map<String, Object> variables = new HashMap<>();

    public static Object get(String name) {
        return variables.get(name);
    }

    public static void set(String name, Object value) {
        variables.put(name, value);
    }
}
