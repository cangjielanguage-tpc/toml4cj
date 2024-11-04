// DEPENDENCE: float001.toml
// DEPENDENCE: float002.toml
// DEPENDENCE: float003.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.posix.*
//let a = ##"{"flt1":"+1.0","flt2":"3.1415","flt3":"-0.01","flt4":"5e+22","flt5":"1e06","flt6":"-2E-2","flt7":"6.626e-34"}"##
let a = ##"{"flt1":"1.0","flt2":"3.1415","flt3":"-0.01","flt4":"5e+22","flt5":"1e06","flt6":"-2E-2","flt7":"6.626e-34"}"##
//let b = ##"{"flt8":"224_617.445_991_228"}"##
let b = ##"{"flt8":"224617.445991228"}"##
//let c = ##"{"flt1":"+1.0","flt2":"3.1415","flt3":"-0.01"}"##
let c = ##"{"flt1":"1.0","flt2":"3.1415","flt3":"-0.01"}"##
main() {
    var path2: String = getcwd()
    let decoder: Decoder = Decoder()
    println(path2)
    decoder.load("${path2}/float001.toml")
    var json = decoder.decode()
    var str: String = json.toString()
    println(str)
    if (str != a) {
        return 1
    }
    decoder.load("${path2}/float002.toml")
    json = decoder.decode()
    str = json.toString()
    println(str)
    if (str != b) {
        return 1
    }
    decoder.load("${path2}/float003.toml")
    json = decoder.decode()
    str = json.toString()
    println(str)
    if (str != c) {
        return 1
    }
    return 0
}