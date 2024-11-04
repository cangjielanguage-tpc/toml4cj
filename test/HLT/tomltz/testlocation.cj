
//3rd_party_lib:toml4cj/build/toml4cj

import toml4cj.decoders.*
import std.posix.*
import std.unittest.*
import std.time.*

/*
    public init(tomlOffset: String)
    public func location(): Location
*/
@Test
public class TomlTzTest{
    var returnFlag: Int32 = 0
    var location:String = ""
    
    @TestCase
    func testLocation():Unit{
        let tomltz_1 = TomlTz("+12:23")
        if(!(tomltz_1.location() is TimeZone)){
            returnFlag = 1
        }
        location = tomltz_1.location().toString()
        @Assert(location,"UTC+12:23")

        let tomltz_2 = TomlTz("Z")
        try{
            location = tomltz_2.location().toString()
        }catch(e1:Exception){
            returnFlag = 2
        }

        @Assert(returnFlag,0)
    }
}
