// DEPENDENCE: quote_test2.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.posix.*

main() {
    var path2: String = getcwd()
    let str: String = "${path2}/quote_test2.toml" 

    try {
        let decoder: Decoder = Decoder()
        decoder.load(str)
        let json = decoder.decode()
        let jsonStr = json.toString()
        println("jsonStr--- ${jsonStr}")
    } catch (e: Exception) {
        println("quote_test2 exception: ${e}")
        return 0
    }
    return 0

}