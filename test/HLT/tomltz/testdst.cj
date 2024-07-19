
//3rd_party_lib:toml4cj/build/toml4cj

import toml4cj.decoders.*
import std.os.posix.*
import std.unittest.*
import std.time.*

/*
    public init(tomlOffset: String)
    public func dst() : Duration
*/
@Test
public class TomlTzTest{
    var returnFlag: Int32 = 0
    var dst:String = ""
    
    @TestCase
    func testTzname():Unit{
        let tomltz_1 = TomlTz("+12:23")
        if(!(tomltz_1.dst() is Duration)){
            returnFlag = 1
        }
        
        dst = tomltz_1.dst().toString()
        @Assert(dst,"0s")

        let tomltz_2 = TomlTz("Z")
        dst = tomltz_2.dst().toString()
        @Assert(dst,"0s")

        try{
            let tomltz_3 = TomlTz("1979-05-27T07:32:00Z") 
            dst = tomltz_3.dst().toString()
            @Assert(dst,"0s")
        }catch(e1:Exception){
            returnFlag = 2
        }
        
        let tomltz_4 = TomlTz("2021-08-04T17:00:00+01:00")
        dst = tomltz_4.dst().toString()
         println("str::> ${dst} ")
        @Assert(dst,"0s")

        @Assert(returnFlag,0)
    }
}
