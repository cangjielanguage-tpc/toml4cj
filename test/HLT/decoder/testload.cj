
//3rd_party_lib:toml4cj/build/toml4cj
//data_file:../sourcefile/source_int.toml
//data_file:testbool.cj
//data_file:../sourcefile/source_other.properties
from toml4cj import decoders.*
from std import os.posix.*
from std import unittest.*
from std import fs.*

/*
    public init()
    public func load(pn: String)
    public func load(file: File)
*/
@Test
public class DecoderTest{
    var returnFlag: Int32 = 0
    var filePath: String = "../sourcefile/source_int.toml" 
    var filePath_1: String = "./testbool.cj"  //入参文件非.toml
    var filePath_2: String = "../sourcefile/source_other.properties"  //入参文件非.toml

    @TestCase
    func testInt():Unit{
        let decoder = Decoder()
        if(!(decoder is Decoder)){
            returnFlag = -1
        }
        //load(pn: String)
        decoder.load(filePath)   
        try {
            decoder.load(filePath)
        } catch (e1: Exception) {
            println("e1>>>> ${e1}")
            returnFlag = 1
        }

        //load(file: File)
        try {
            let file = File(filePath_2,OpenOption.Open(true,true))
            decoder.load(file)   
        } catch (e2: Exception){
            println("e2>>>> ${e2}")
             @Assert(e2.toString().contains("IllegalArgumentException: The format of the file is not supported."),true)
             returnFlag = returnFlag
        }
        @Assert(returnFlag,0)
    }

}
