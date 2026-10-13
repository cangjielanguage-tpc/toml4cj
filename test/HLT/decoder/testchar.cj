
//3rd_party_lib:toml4cj/build/toml4cj
//data_file:../sourcefile/source_char.toml
import toml4cj.decoders.*
import std.posix.*
import std.unittest.*
import std.fs.*

/*
    public init()
    public func load(pn: String)
    public func load(file: File)
    public func decode(): JsonObject
*/
@Test
public class DecoderTest{
    var returnFlag: Int32 = 0
    var filePath: String = "../sourcefile/source_char.toml" 
    var filePath_1: String = "../source哦吼/file/source_char.toml"  //文件路径不存在
    var strData:String = ""

    @TestCase
    func testChar():Unit{
        let decoder = Decoder()
        if(!(decoder is Decoder)){
            returnFlag = 1
        }
        decoder.load(filePath)   
        try {
            Decoder().load(filePath_1)
        } catch (e1: Exception) {
            @Assert(e1.toString().contains("does not exist"),true)
        }
        strData =  decoder.decode().toString()
        var arr_str_1:Array<String> = strData[1..strData.size -1].split(",")
        @Assert(arr_str_1.size,7)
        //@Assert(arr_str_1[5],"\"char_6\":\"t\"")
        @Assert(arr_str_1[5], ##""char_6":"\\t""##)

        //load(file: File)
        let file = File(filePath,OpenMode.ReadWrite)
        decoder.load(file)   
        strData =  decoder.decode().toString()
        var arr_str_2:Array<String> = strData[1..strData.size -1].split(",")
        if(arr_str_1 != arr_str_2){
             returnFlag = 2
        }
        @Assert(arr_str_2.size,7)
        //@Assert(arr_str_2[6],"\"char_7\":\"u{4f60}\"")
        @Assert(arr_str_2[6], ##""char_7":"\\u{4f60}""##)

        @Assert(returnFlag,0)
    }


}
