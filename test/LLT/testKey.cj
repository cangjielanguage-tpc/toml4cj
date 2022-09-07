// DEPENDENCE: keys001.toml
// DEPENDENCE: keys002.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml import decoders.*
from std import os.posix.*
let a = ##"{"key":"value","bare_key":"value","bare-key":"value","1234":"value"}"##
let b = ##"{"127":{"0":{}},"1":"value",""character encoding"":"value",""ʎǝʞ"":"value","'key2'":"value","'quoted "value"'":"value"}"##
main() {
    var path2: String = getcwd()
    let decoder: Decoder = Decoder()
    decoder.load("${path2}/keys001.toml")
    var json = decoder.decode()
    if (json.toString() != a) {
        return 1
    }
    decoder.load("${path2}/keys002.toml")
    json = decoder.decode()
    if (json.toString() != b) {
        return 2
    }
    return 0
}