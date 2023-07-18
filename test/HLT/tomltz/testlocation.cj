
//3rd_party_lib:toml4cj/build/toml4cj

from toml4cj import decoders.*
from std import os.posix.*
from std import unittest.*
from std import time.*

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
        if(!(tomltz_1.location() is Location)){
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

        try{
            let tomltz_3 = TomlTz("1979-05-27T07:32:00Z") 
            location = tomltz_3.location().toString()
        }catch(e2:Exception){
            returnFlag = 3
        }
        
        let tomltz_4 = TomlTz("2021-08-04T17:00:00+01:00")
        try{
            location = tomltz_4.location().toString()
        }catch(e3:Exception){
            returnFlag = 4
        }
        @Assert(returnFlag,0)
    }
}
