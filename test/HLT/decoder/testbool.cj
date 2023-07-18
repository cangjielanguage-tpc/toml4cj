//3rd_party_lib:toml4cj/build/toml4cj
//data_file:../sourcefile/source_bool.toml
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
public class DecoderTest {
    var returnFlag: Int32 = 0
    var filePath: String = "../sourcefile/source_bool.toml"
    var filePath_1: String = "../sourcefile/source_bool.tomlxc" //文件后缀不符  
    var strData: String = ""

    @TestCase
    func testBool(): Unit {
        let decoder = Decoder()
        if (!(decoder is Decoder)) {
            returnFlag = 1
        }
        try{
            decoder.load(filePath)
        }catch(e1: Exception){
            returnFlag = 2
        }
        try {
            let decoder_2 = Decoder()
            decoder_2.load(filePath_1)
        } catch (e2: Exception) {
            @Assert(e2.toString().contains("FSException: The file does not exist!"),true)
            returnFlag = 0
        }
        try {
            strData = decoder.decode().toString()
        } catch (e3: Exception) {
            returnFlag = 3
        }
        @Assert(strData,"{\"bool_2\":\"true\",\"bool_3\":\"false\",\"bool_4\":\"true\"}")
        var arr_str_1: Array<String> = strData.substring(1, strData.size - 2).split(",")
        @Assert(arr_str_1.size,3)
        @Assert(arr_str_1[0],"\"bool_2\":\"true\"")

        //load(file: File)
        let file = File(filePath,OpenOption.Open(true,true))
        decoder.load(file)
        strData = decoder.decode().toString()

        //println("strData::> ${strData}")
        var arr_str_2: Array<String> = strData.substring(1, strData.size - 2).split(",")
        if (arr_str_1 != arr_str_2) {
            returnFlag = 4
        }
        @Assert(arr_str_2.size,3)
        @Assert(arr_str_2[1],"\"bool_3\":\"false\"") 
        @Assert(returnFlag,0)
    }
}
