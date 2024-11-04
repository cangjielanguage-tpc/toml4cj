// DEPENDENCE: keyvalue001.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.posix.*
let a = ##"{"key":"value"}"##
main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/keyvalue001.toml"
        ]
    let decoder: Decoder = Decoder()
    for(i in 0..arr.size) {
        decoder.load(arr[i])
        let json = decoder.decode()
        if (json.toString() != a) {
            return 1
        }
    }
    return 0
}