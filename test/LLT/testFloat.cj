// DEPENDENCE: float001.toml
// DEPENDENCE: float002.toml
// DEPENDENCE: float003.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml import decoders.*
from std import os.posix.*

main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/float001.toml" , 
        "${path2}/float002.toml",
        "${path2}/float003.toml"
        ]
    let decoder: Decoder = Decoder()
    for(i in 0..arr.size()) {
        decoder.load(arr[i])
        decoder.decode()
    }
}