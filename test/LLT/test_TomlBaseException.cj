// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*

main() {
    var tomlBaseException1 = TomlBaseException()
    var TomlDecodeErrorException1 = TomlDecodeErrorException()
    var TomlIllegalKeyException1 = TomlIllegalKeyException()
    var TomlIllegalKeyException2 = TomlIllegalKeyException("error")
    var TomlIllegalValueException1 = TomlIllegalValueException()
    var TomlIllegalValueException2 = TomlIllegalValueException("error")
}