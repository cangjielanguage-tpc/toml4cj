// DEPENDENCE: localdatetime001.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml4cj import decoders.*
from std import os.posix.*

//不支持解析时间格式
main() {
    var path2: String = getcwd()
    var arr: Array<String> = [
        "${path2}/localdatetime001.toml"
        ]
    let decoder: Decoder = Decoder()

    try {
        for(i in 0..arr.size) {
            decoder.load(arr[i])
            decoder.decode()
        }
    }catch (e: Exception) {
        e.printStackTrace()
        return 0
    }
    return 1
}