// DEPENDENCE: localdatetime001.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml import decoders.*
from std import os.posix.*

main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/localdatetime001.toml"
        ]
    let decoder: Decoder = Decoder()
    for(i in 0..arr.size()) {
        decoder.load(arr[i])
        decoder.decode()
    }
}