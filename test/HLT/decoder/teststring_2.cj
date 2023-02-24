//3rd_party_lib:toml/build/toml
//data_file:../sourcefile/source_string_complex.toml

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
    var returnFlag: Int32 = -1
    var path2: String = getcwd()
    var filePath: String = "../sourcefile/source_string_complex.toml"  //原始toml中含不支持的类型
    var strData:String = ""

    @TestCase
    func testStringAbNomal():Unit{
        let decoder = Decoder()
        //load(pn: String)
        decoder.load(filePath)   
        try{
            var jsonObj = decoder.decode()
            strData = jsonObj.toString()
            var arr_str_1:Array<String> = strData.substring(1,strData.size -2).split(",")
        }catch(e1:Exception){
             @Assert(e1.toString().contains("Exception: Found invalid character in key name: '.' Try quoting the key name."),true)
             returnFlag = 0
        }
        @Assert(returnFlag,0)
    }

}
