package enumerations

public enum KeyName {
    | Str(String)
    | List(KeyName)
}