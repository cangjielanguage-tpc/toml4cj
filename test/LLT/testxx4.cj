// DEPENDENCE: testxx4.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.posix.*

main() {
    var path2: String = getcwd()
    let str: String = "${path2}/testxx4.toml" 

    try {
        let decoder: Decoder = Decoder()
        decoder.load(str)
        let json = decoder.decode()
        let jsonStr = json.toString()
        println("jsonStr--- ${jsonStr}")
    } catch (e: Exception) {
        println("eeee ${e.toString()}")
        return 1
    }
    return 0

}