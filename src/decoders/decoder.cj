/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package decoders

from std import io.*
import enumerations.*
from std import collection.*
import exceptions.*
from std import regex.*
from std import unicode.*
from std import serialization.*

type element = HashMap<Key, Value>

public class Decoder {
    var stream: Option<Stream> = None
    var data: Option<String> = None
    var mode: DecodeMode = DecodeMode.UNSPECIFIED
    // static let booleanParser: BooleanParser = BooleanParser()
    // static let dateTimeParser: DateTimeParser = DateTimeParser()
    // static let floatParser: FloatParser = FloatParser()
    // static let integerParser: IntegerParser = IntegerParser()
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
        let implicitGroups: ArrayList<Any> = ArrayList<Any>()

        let original: String = readData()
        var sl: Array<Char> = original.toCharArray()
        let openArr: Int64 = 0
        var openString: Bool = false
        var openStrChar: Char = ""[0]
        let multilineStr: Bool = false
        let arrayOfTables: Bool = false
        let beginLine: Bool = true
        let keyGroup: Bool = false
        var dottedKey: Bool = false
        var keyName: Int64 = 0
        var key: String = ""
        var prevKey: String = ""
        let lineNo: Int64 = 1

        for (i in 0..sl.size()) {
            let item: Char = sl[i]
            if(item == Symbols.CR[0] && sl[i + 1] == Symbols.LF[0]) {
                sl[i] = chr(0x20) // ' '
                continue
            }
            if (0 != keyName) {
                key += item
                if (item == Symbols.LF[0]) {
                    throw TomlDecodeErrorException("Key name found without value. Reach end of line.")
                }
                if (openString) {
                    if (item == openStrChar) {
                        var oddBackSlash: Bool = false
                        var k: Int64 = 1
                        while (i >= k && sl[i - k] == chr(0x5C)) {
                            oddBackSlash = !oddBackSlash
                            k += 1
                        }
                        if (!oddBackSlash) {
                            keyName = 2
                            openString = false
                            openStrChar = ""[0]
                        }
                    }
                    continue
                } else if(keyName == 1) {
                    if (item.isAsciiWhiteSpace()) {
                        keyName = 2
                        continue
                    } else if (item == Symbols.DOT[0]) {
                        dottedKey = true
                        continue
                    } else if ((item.isAsciiLetter() && item.isAsciiNumber()) || item == Symbols.UNDERLINE[0] || item == Symbols.DASHED[0]) {
                        continue
                    } else if (dottedKey && sl[i - 1] == Symbols.DOT[0] && (item == Symbols.QUOTE[0] || item == Symbols.SINGLE_QUOTE[0])) {
                        openString = true
                        openStrChar = item
                        continue
                    }
                } else if (keyName == 2) {
                    if (item.isAsciiWhiteSpace()) {
                        if (dottedKey) {
                            let nextItem: Char = sl[i + 1]
                            if ((!nextItem.isAsciiWhiteSpace()) && nextItem != Symbols.DOT[0]) {
                                keyName = 1
                            }
                        }
                        continue
                    }
                    if (item == Symbols.DOT[0]) {
                        dottedKey = true
                        let nextItem: Char = sl[i + 1]
                        if ((!nextItem.isAsciiWhiteSpace()) && nextItem != Symbols.DOT[0]) {
                            keyName = 1
                        }
                        continue
                    }
                }
                if (item == Symbols.EQUAL_SYMBOL[0]) {
                    keyName = 0
                    prevKey = key[..-1].rtrim()
                }
            }
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