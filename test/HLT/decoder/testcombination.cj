
//3rd_party_lib:toml/build/toml
//data_file:../sourcefile/source_combination.toml
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
    var filePath: String = "../sourcefile/source_combination.toml"  
    var strData:String = ""
    

    @TestCase
    func testChar():Unit{
        let decoder = Decoder()
        if(!(decoder is Decoder)){
            returnFlag = 1
        }
        //load(pn: String)
        decoder.load(filePath)   
        strData =  decoder.decode().toString()
        var arr_str_1:Array<String> = strData.substring(1,strData.size -2).split(",")
        @Assert(arr_str_1.size,35)
        @Assert(arr_str_1[0],"\"str_1\":\"99 > 10\"")

        //load(file: File)
        let file = File(filePath,OpenOption.Open(true,true))
        decoder.load(file)   
        strData =  decoder.decode().toString()
        var arr_str_2:Array<String> = strData.substring(1,strData.size -2).split(",")
        if(arr_str_1 != arr_str_2){
             returnFlag = 2
        }
         @Assert(arr_str_2.size,35)
         @Assert(arr_str_2[arr_str_2.size -1],"\"int8\":\"0o242\"")

        @Assert(returnFlag,0)
    }


}
