//3rd_party_lib:toml4cj/build/toml4cj
//data_file:../sourcefile/source_string_single.toml
import toml4cj.decoders.*
import std.posix.*
import std.unittest.*
import std.fs.*
internal import stdx.encoding.json.*
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
        var arr_str_1:Array<String> = strData[1..strData.size -1].split(",")
        //println("strData1::> ${strData}")
        @Assert(arr_str_1.size,8)
        @Assert(arr_str_1[0],"\"str_1\":\"99 > 10\"") 
        @Assert(arr_str_1[3].size,400)

        //load(file: File)
        let file = File(filePath,OpenMode.ReadWrite)
        decoder.load(file)   
        strData =  decoder.decode().toString()
        var arr_str_2:Array<String> = strData[1..strData.size -1].split(",")
        if(arr_str_1 != arr_str_2){
             returnFlag = 2
        }
        @Assert(arr_str_2.size,8)
        @Assert(returnFlag,0)
    }


}
