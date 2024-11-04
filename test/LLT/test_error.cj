// DEPENDENCE: error.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.posix.*


main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/error.toml" 
        ]
    let decoder: Decoder = Decoder()

    try {
        for(i in 0..arr.size) {
            decoder.load(arr[i])
            let a = decoder.decode()
        }
    }catch (e: Exception) {
        e.printStackTrace()
        return 0
    }
    return 1
}