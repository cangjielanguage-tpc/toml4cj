/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package decoders

from std import io.*
import enumerations.*
from std import collection.*
import decoders.parsers.IntegerParser
import exceptions.*
from std import regex.*


public class Decoder {
    var stream: Option<Stream> = None
    var data: Option<String> = None
    var mode: DecodeMode = DecodeMode.UNSPECIFIED
    // static let booleanParser: BooleanParser = BooleanParser()
    // static let dateTimeParser: DateTimeParser = DateTimeParser()
    // static let floatParser: FloatParser = FloatParser()
    static let integerParser: IntegerParser = IntegerParser()
    // static let listParser: ListParser = ListParser()
    // static let mapParser: MapParser = MapParser()
    // static let stringParser: StringParser = StringParser()
    static let DEFAULT_BUFFER_SIZE = 2 << 11  // 4096

    public init() {

    }

    public init(payload: String) {
        mode = DecodeMode.STRING
        data = Some(payload)
    }

    public func load(pn: String) {
        load(FileStream(pn))
    }

    public func load(file: FileStream) {
        match(data) {
            case Some(x) => throw Exception("Can't use string decode and stream decode at the same time")
            case None => {}
        }
        mode = DecodeMode.STREAM
        if(!file.openFile()) {
            // Todo: Use custom exception instead it
            throw Exception("Open file failed")
        }
        stream = Some(file)
    }

    public func loads(payload: String) {
        match(stream) {
            case Some(x) => throw Exception("Can't use string decode and stream decode at the same time")
            case None => {}
        }
        mode = DecodeMode.STRING
        data = Some(payload)
    }

    public func decode() {
        let data: String = readData()
        let sep: String
        // Todo: Multi-line string is not implement
        let lines: Array<String> = match {
            case (0 < data.indexOf(Symbols.CRLF).getOrDefault({ => -1})) => sep = Symbols.CRLF
                                                                            data.split(Symbols.CRLF, removeEmpty: false)
            case (0 < data.indexOf(Symbols.LF).getOrDefault({=> -1})) => sep = Symbols.LF
                                                                         data.split(Symbols.LF, removeEmpty: false)
            case _ => throw Exception("Invalid toml")
        }

        for (line in lines) {
            let lineTrimedLeft = line.trimAsciiLeft()
            // Ignore the comment line
            if (lineTrimedLeft.startsWith(Symbols.NUMBER_SIGN)) {
                continue
            }
            // Todo: parse key
            if (lineTrimedLeft.startsWith(Symbols.EQUAL_SYMBOL)) {
                throw TomlIllegalKeyException("Illegal toml key: the key is empty")
            }
            
            var key: Buffer<String> = Buffer<String>()
            if (lineTrimedLeft.startsWith(Symbols.LEFT_SQUARE_BRACKET)) {
                // Todo: Table
            }
            
            let a: String = lineTrimedLeft.split(Symbols.EQUAL_SYMBOL, 2)[0]
            // "127.0.0.1" = "value"
            // Todo
            // foo = "bar"
            let keyMatcher: Matcher = Regex("[a-zA-Z0-9_-]+").matcher(a)
            keyMatcher.fullMatch().getOrThrow({ => TomlIllegalKeyException("Illegal toml key: the key is illegal")})
            key.add(a)

            // Todo: 处理多行文本
            // Todo：处理其他类型数据
            // 处理整型数据
            let v: Int64 = match(integerParser.asA(line)) {
                case Ok(x) => match(x) {
                    case Integer(y) => y
                    case _ => -1
                }
                case Err(_) => throw Exception("Not an integer")
            }

            // 处理布尔型数据
        }
        
    }

    private func readData(): String {
        let data: String = match(mode) {
            case STREAM => { => let s: Stream = match(stream) {
                                    case Some(st: Stream) => st
                                    case _ => throw Exception("The stream must be initialize")
                                }
                                let res: StringBuilder = StringBuilder()
                                var readLength: Int64 = 0
                                var buffer: Array<UInt8> = Array<UInt8>(DEFAULT_BUFFER_SIZE, item: 0)
                                do {
                                    readLength = s.read(buffer)
                                    if (0 != readLength) {
                                        res.append(String.fromUtf8(buffer, start: 0, length: readLength))
                                    }
                                } while (readLength == DEFAULT_BUFFER_SIZE)
                                res.toString()}()
            case STRING => match(data) {
                                case d: String => d
                                case _ => throw Exception("Must specify the data")
                           }
            case _ => throw Exception("Must specify the data source first")
        }
        data
    }
}