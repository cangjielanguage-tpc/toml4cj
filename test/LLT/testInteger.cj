// DEPENDENCE: integer001.toml
// DEPENDENCE: integer002.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml import decoders.*
from std import os.posix.*

main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/integer001.toml" , 
        "${path2}/integer002.toml"
        ]
    let decoder: Decoder = Decoder()
    for(i in 0..arr.size()) {
        decoder.load(arr[i])
        let a = decoder.decode()
        println(a)
    }
}