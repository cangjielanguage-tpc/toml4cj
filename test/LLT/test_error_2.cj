// DEPENDENCE: error2.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.os.posix.*


main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/error2.toml"
        ]
    let decoder: Decoder = Decoder()
    for(i in 0..arr.size) {
        decoder.load(arr[i])
        let a = decoder.decode()
    }
    return 0
}