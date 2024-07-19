// DEPENDENCE: keys001.toml
// DEPENDENCE: keys002.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.os.posix.*

let a = ##"{"key":"value","bare_key":"value","bare-key":"value","1234":"value"}"##
let b = ##"{"127":{"0":{}},"1":"value","\"character encoding\"":"value","\"ʎǝʞ\"":"value","'key2'":"value","'quoted \"value\"'":"value"}"##

//CI上的转义字符会丢失:
//因为是python开了一个进程  读取子进程的输出再打印出来  所以不是最原始的信息
let b_ci = ##"{"127":{"0":{}},"1":"value",""character encoding"":"value",""ʎǝʞ"":"value","'key2'":"value","'quoted "value"'":"value"}"##
main() {

    let decoder: Decoder = Decoder()
    decoder.load("keys001.toml")
    var json = decoder.decode()
    if (json.toString() != a) {
        return 1
    }
    decoder.load("keys002.toml")
    json = decoder.decode()
    println(json.toJsonString())
    if (!(json.toString() == b) || json.toString() == b_ci) {
        return 2
    }
    return 0
}