// DEPENDENCE: string001.toml
// DEPENDENCE: string002.toml
// DEPENDENCE: string003.toml
// DEPENDENCE: string004.toml
// DEPENDENCE: string005.toml
// DEPENDENCE: string006.toml
// DEPENDENCE: string007.toml
// DEPENDENCE: string008.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml import decoders.*
from std import os.posix.*

main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/string001.toml" , 
        "${path2}/string002.toml", 
        "${path2}/string003.toml",
        "${path2}/string004.toml",
        "${path2}/string005.toml",
        "${path2}/string006.toml",
        "${path2}/string007.toml",
        "${path2}/string008.toml"
        ]
    let decoder: Decoder = Decoder()
    for(i in 0..arr.size()) {
        decoder.load(arr[i])
        let a = decoder.decode()
        println(a)
    }
}