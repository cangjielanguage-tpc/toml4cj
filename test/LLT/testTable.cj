// DEPENDENCE: table001.toml
// DEPENDENCE: table002.toml
// DEPENDENCE: table003.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml import decoders.*
from std import os.posix.*

main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/table001.toml" , 
        "${path2}/table002.toml", 
        "${path2}/table003.toml"
        ]
    let decoder: Decoder = Decoder()
    for(i in 0..arr.size) {
        decoder.load(arr[i])
        decoder.decode()
    }
}