//3rd_party_lib:toml/build/toml
//data_file:../sourcefile/source_string_single.toml
from toml import decoders.*
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
    var path2: String = getcwd()
    var filePath: String = "../sourcefile/source_string_single.toml" 
    var strData:String = ""

    @TestCase
    func testStringNomal():Unit{
        let decoder = Decoder()
        //load(pn: String)
        decoder.load(filePath)   
        var jsonObj = decoder.decode()
        if(!(jsonObj is JsonObject)){
            returnFlag = 1
        }
        strData = jsonObj.toString()
        var arr_str_1:Array<String> = strData.substring(1,strData.size -2).split(",")
        //println("strData1::> ${strData}")
        @Assert(arr_str_1.size,8)
        @Assert(arr_str_1[0],"\"str_1\":\"99 > 10\"") 
        @Assert(arr_str_1[3].size,376)

        //load(file: File)
        let file = File(filePath,OpenOption.Open(true,true))
        decoder.load(file)   
        strData =  decoder.decode().toString()
        var arr_str_2:Array<String> = strData.substring(1,strData.size -2).split(",")
        if(arr_str_1 != arr_str_2){
             returnFlag = 2
        }
        @Assert(arr_str_2.size,8)
        @Assert(returnFlag,0)
    }


}
