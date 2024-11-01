
//3rd_party_lib:toml4cj/build/toml4cj
//data_file:testbool.cj
//data_file:../sourcefile/source_other.properties
import toml4cj.decoders.*
import std.posix.*
import std.unittest.*
import std.fs.*

/*
    public init()
    public func load(pn: String)
    public func load(file: File)
*/
@Test
public class DecoderTest{
    var returnFlag: Int32 = -1
    var strData:String = ""
    var arr_str:Array<String> = Array<String>()  
    var filePath_1: String = "./testbool.cj"  //入参文件非.toml
    var filePath_2: String = "../sourcefile/source_other.properties"  //入参文件非.toml

    @TestCase
    func testInt():Unit{
        let decoder = Decoder() 
        try {
            decoder.load(filePath_1)
            strData =  decoder.decode().toString()
            arr_str = strData[1..strData.size -1].split(",")
        } catch (e1: Exception) {
            @Assert(e1.toString().contains("The format of the file is not supported."),true)
            returnFlag = 0
        }

        //load(file: File)
        let decoder_2 = Decoder() 
        try {
            let file = File(filePath_2,OpenOption.Open(true,true))
            decoder_2.load(file)   
            strData =  decoder_2.decode().toString()
            println("strData::> ${strData}")
        } catch (e2: Exception){
            // println("e2::> ${e2}")
             @Assert(e2.toString().contains("IllegalArgumentException: The format of the file is not supported."),true)
             returnFlag = 0
        }
       @Assert(returnFlag,0)
    }


}
