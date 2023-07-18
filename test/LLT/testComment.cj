// DEPENDENCE: comment001.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml4cj import decoders.*
from std import os.posix.*
let str = ##"{"key":"value","another":"# This is not a comment"}"##
main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/comment001.toml"
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