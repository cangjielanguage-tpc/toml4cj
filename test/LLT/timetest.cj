// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import std.posix.*
import std.time.*

var returnFlag: Int32 = 0
var dst:String = ""
main() {
    let tomltz_1 = TomlTz("+12:23")
    if(!(tomltz_1.dst() is Duration)){
        return 1
    }
    dst = tomltz_1.dst().toString()
    if (dst != "0s") {
        return 1
    }

    let tomltz_2 = TomlTz("Z")
    dst = tomltz_2.dst().toString()
    if (dst != "0s") {
        return 1
    }
    try{
        let tomltz_3 = TomlTz("1979-05-27T07:32:00Z") 
        dst = tomltz_3.dst().toString()
        if (dst != "0s") {
            return 1
        }
    }catch(e1:Exception){
        return  2
    }
    
    let tomltz_4 = TomlTz("2021-08-04T17:00:00+01:00")
    dst = tomltz_4.dst().toString()
    println("str::> ${dst} ")
    if (dst != "0s") {
        return 1
    }
    
    let tomltz_1_1 = TomlTz("+12:23")
    if(!(tomltz_1_1.location() is TimeZone)){
        return 2
    }
    var  location = tomltz_1_1.location().toString()
    if (location != "UTC+12:23") {
        return 3
    }

    let tomltz_2_2 = TomlTz("+12:10")
    try{
        location = tomltz_2_2.location().toString()
    }catch(e1:Exception){
        return  4
    }

    try{
        let tomltz_3_3 = TomlTz("+12:10") 
        var tzname = tomltz_3_3.tzname()
    }catch(e1:Exception){ 
        println(e1.toString())
        return 5
    }
    return 0
}
