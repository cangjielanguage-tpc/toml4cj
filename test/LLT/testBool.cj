// DEPENDENCE: boolean001.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.posix.*

let str = ##"{"bool1":"true","bool2":"false"}"##
main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/boolean001.toml" 
        ]
    let decoder: Decoder = Decoder()
    for(i in 0..arr.size) {
        decoder.load(arr[i])
        let a = decoder.decode()
        if (a.toString() != str) {
            return 1
        }
    }
    return 0
}