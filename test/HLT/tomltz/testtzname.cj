
//3rd_party_lib:toml4cj/build/toml4cj

import toml4cj.decoders.*
import std.os.posix.*
import std.unittest.*

/*
    public init(tomlOffset: String)
    public func tzname(): String
*/
@Test
public class TomlTzTest{
    var returnFlag: Int32 = -1
    var tzname:String = ""
    
    @TestCase
    func testTzname():Unit{
        let tomltz_1 = TomlTz("+12:23")
        if(!(tomltz_1 is TomlTz)){
            returnFlag = 1
        }
        
        tzname = tomltz_1.tzname()
        @Assert(tzname,"UTC+12:23")

        let tomltz_2 = TomlTz("Z")
        tzname = tomltz_2.tzname()
        @Assert(tzname,"UTC+00:00")

        try{
            let tomltz_3 = TomlTz("哈嘿哦吼") 
            tzname = tomltz_3.tzname()
        }catch(e1:Exception){
            println(e1.toString())
            @Assert(e1.toString().contains("IllegalArgumentException"),true)
            returnFlag = 0
        }
        
        let tomltz_4 = TomlTz("2021-08-04T17:00:00+01:00")
        tzname = tomltz_4.tzname()
        // println("str::> ${tzname} ")
        @Assert(tzname,"UTC2021-08-04T17:00:00+01:00")
        @Assert(returnFlag,0)
    }
}
