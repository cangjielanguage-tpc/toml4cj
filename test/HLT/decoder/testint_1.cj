
//3rd_party_lib:toml4cj/build/toml4cj
//data_file:../sourcefile/source_int.toml
import toml4cj.decoders.*
import std.posix.*
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
        arr_str = strData[1..strData.size -1].split(",")
        @Assert(arr_str.size,10)
        //@Assert(arr_str[0],"\"int1\":\"+99\"")
        @Assert(arr_str[0],"\"int1\":\"99\"")

        //load(file: File)
        let file = File(filePath,OpenMode.ReadWrite)
        decoder.load(file)   
        strData =  decoder.decode().toString()
        // println("strData::> ${strData}")
        arr_str = strData[1..strData.size -1].split(",")
        @Assert(arr_str.size,10)
        @Assert(arr_str[9],"\"int8\":\"0o242\"")


        @Assert(returnFlag,0)
    }


}
