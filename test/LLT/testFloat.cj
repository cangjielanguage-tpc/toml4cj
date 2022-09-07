// DEPENDENCE: float001.toml
// DEPENDENCE: float002.toml
// DEPENDENCE: float003.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml import decoders.*
from std import os.posix.*
let a = ##"{"flt1":"+1.0","flt2":"3.1415","flt3":"-0.01","flt4":"5e+22","flt5":"1e06","flt6":"-2E-2","flt7":"6.626e-34"}"##
let b = ##"{"flt8":"224_617.445_991_228"}"##
let c = ##"{"flt1":"+1.0","flt2":"3.1415","flt3":"-0.01"}"##
main() {
    var path2: String = getcwd()
    let decoder: Decoder = Decoder()
    decoder.load("${path2}/float001.toml")
    var json = decoder.decode()
    if (json.toString() != a) {
        return 1
    }
    decoder.load("${path2}/float002.toml")
    json = decoder.decode()
    if (json.toString() != b) {
        return 1
    }
    decoder.load("${path2}/float003.toml")
    json = decoder.decode()
    if (json.toString() != c) {
        return 1
    }
    return 0
}