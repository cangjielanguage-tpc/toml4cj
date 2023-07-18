// DEPENDENCE: integer001.toml
// DEPENDENCE: integer002.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml4cj import decoders.*
from std import os.posix.*
let a = ##"{"int1":"+99","int2":"42","int3":"0","int4":"-17"}"##
let b = ##"{"int5":"1_000","int6":"5_349_221","int7":"53_49_221","int8":"1_2_3_4_5"}"##
main() {
    var path2: String = getcwd()
    let decoder: Decoder = Decoder()
    decoder.load("${path2}/integer001.toml")
    var json = decoder.decode()
    if (json.toString() != a) {
        return 1
    }
    decoder.load("${path2}/integer002.toml")
    json = decoder.decode()
    if (json.toString() != b) {
        return 2
    }
    return 0
}