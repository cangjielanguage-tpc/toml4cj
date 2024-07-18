
//3rd_party_lib:toml4cj/build/toml4cj
//data_file:../sourcefile/source_float.toml
import toml4cj.decoders.*
import std.os.posix.*
import std.unittest.*
import std.fs.*
import encoding.json.*

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
    var filePath: String = "../sourcefile/source_float.toml" 
    var filePath_1: String = "../sourcefile/"  //当前为一文件目录，非文件
    var strData:String = ""
    

    @TestCase
    func testFloat():Unit{
        let decoder = Decoder()
        //load(pn: String)
        decoder.load(filePath)   
        var jsonObj = decoder.decode()
        if(!(jsonObj is JsonObject)){
            returnFlag = 1
        }
        try {
            Decoder().load(filePath_1)
        } catch (e1: Exception) {
            // println("e1_000>>>> ${e1}")
            @Assert(e1.toString().contains("IllegalArgumentException: The format of the file is not supported."),true)
        }
        strData = jsonObj.toString()
        var arr_str_1:Array<String> = strData[1..strData.size -1].split(",")
        @Assert(arr_str_1.size,7)
        //@Assert(arr_str_1[0],"\"flt1\":\"+1.0\"")
        @Assert(arr_str_1[0],"\"flt1\":\"1.0\"")
        @Assert(arr_str_1[2],"\"flt3\":\"-0.01\"")

        //load(file: File)
        let file = File(filePath,OpenOption.Open(true,true))
        decoder.load(file)   
        strData =  decoder.decode().toString()
        // println("strData2::> ${strData}")
        var arr_str_2:Array<String> = strData[1..strData.size -1].split(",")
        if(arr_str_1 != arr_str_2){
             returnFlag = 2
        }
        @Assert(arr_str_2.size,7)
        @Assert(arr_str_2[6],"\"flt7\":\"6.626e-34\"")

        @Assert(returnFlag,0)
    }


}
