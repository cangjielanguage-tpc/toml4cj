// DEPENDENCE: test.properties
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml4cj import decoders.*
from std import os.posix.*
main () {
    var path2: String = "${getcwd()}/test.properties"
    let decoder: Decoder = Decoder()
    try {
        decoder.load(path2)
    } catch (e: IllegalArgumentException) {
        if (e.toString() == "IllegalArgumentException: The format of the file is not supported.") {
            return 0
        }
        return 1
    }
    let a = decoder.decode()
    println(a)
    return 1
}