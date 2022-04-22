package exceptions

public class TomlDecodeErrorException <: TomlBaseException {
    public init() {
        this("Some error occurred when decode the toml data")
    }

    public init(message: String) {
        super(message)
    }
}