// DEPENDENCE: quote_test1.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.os.posix.*

main() {
    var path2: String = getcwd()
    let str: String = "${path2}/quote_test1.toml" 

    try {
        let decoder: Decoder = Decoder()
        decoder.load(str)
        let json = decoder.decode()
        let jsonStr = json.toString()
        println("jsonStr--- ${jsonStr}")
    } catch (e: Exception) {
        return 1
    }
    return 0

}