
//3rd_party_lib:toml4cj/build/toml4cj
//data_file:../sourcefile/source_int.toml
from toml4cj import decoders.*
from std import os.posix.*
from std import unittest.*
from std import fs.*
from encoding import json.*

/*
    public init()
    public func load(pn: String)
    public func load(file: File)
    public func decode(): JsonObject
*/
@Test
public class DecoderTest{
    var returnFlag: Int32 = 0
    var filePath: String = "../sourcefile/source_int.toml" 
    var strData:String = ""
    var arr_str:Array<String> = Array<String>()

    @TestCase
    func testInt():Unit{
        let decoder = Decoder()
        if(!(decoder is Decoder)){
            returnFlag = 1
        }
        //load(pn: String)
        decoder.load(filePath)   
        strData =  decoder.decode().toString()
        var bb:JsonValue = JsonValue.fromStr(strData)
        // println("a::> ${strData}")
        arr_str = strData.substring(1,strData.size -2).split(",")
        @Assert(arr_str.size,10)
        @Assert(arr_str[0],"\"int1\":\"+99\"")

        //load(file: File)
        let file = File(filePath,OpenOption.Open(true,true))
        decoder.load(file)   
        strData =  decoder.decode().toString()
        // println("strData::> ${strData}")
        arr_str = strData.substring(1,strData.size -2).split(",")
        @Assert(arr_str.size,10)
        @Assert(arr_str[9],"\"int8\":\"0o242\"")


        @Assert(returnFlag,0)
    }


}
