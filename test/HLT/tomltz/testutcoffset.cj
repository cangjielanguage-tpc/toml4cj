//3rd_party_lib:toml4cj/build/toml4cj

import toml4cj.decoders.*
import std.posix.*
import std.unittest.*
import std.time.*

/*
    public init(tomlOffset: String)
    public func utcOffset(): Duration
*/
@Test
public class TomlTzTest{
    var returnFlag: Int32 = 0
    var tzname:String = ""
    var utcOffset:String = ""
    @TestCase
    func testUtcOffset():Unit{
        let tomltz_1 = TomlTz("+12:23")
        utcOffset = tomltz_1.utcOffset().toString()
        @Assert(utcOffset,"-23m")

        try{
        let tomltz_2 = TomlTz("Z")
        utcOffset = tomltz_2.utcOffset().toString()
        }catch(e1:Exception){
            returnFlag = 1
        }

        try{
            let tomltz_3 = TomlTz("1979-05-27T07:32:00Z") 
            utcOffset = tomltz_3.utcOffset().toString()
        }catch(e2:Exception){
            returnFlag = 2
        }
        
        try{
            let tomltz_4 = TomlTz("2021-08-04T17:00:00+01:00")
            tzname = tomltz_4.tzname()
            @Assert(tzname,"UTC2021-08-04T17:00:00+01:00")
            utcOffset = tomltz_4.utcOffset().toString()
        }catch(e3:Exception){
            returnFlag = 3
        }
        @Assert(returnFlag,0)
    }
}
