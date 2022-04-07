/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package decoders

from std import io.*
import enumerations.*
from std import collection.*


public class Decoder {
    var stream: Option<Stream> = None
    var data: Option<String> = None
    var mode: DecodeMode = DecodeMode.UNSPECIFIED
    static let booleanParser: BooleanParser = BooleanParser()
    static let dateTimeParser: DateTimeParser = DateTimeParser()
    static let floatParser: FloatParser = FloatParser()
    static let integerParser: IntegerParser = IntegerParser()
    static let listParser: ListParser = ListParser()
    static let mapParser: MapParser = MapParser()
    static let stringParser: StringParser = StringParser()
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
        // Todo: Multi-line string is not implement
        let lines: Array<String> = match {
            case (0 < data.indexOf(Symbols.CRLF).getOrDefault({ => -1})) => data.split(Symbols.CRLF, removeEmpty: true)
            case (0 < data.indexOf(Symbols.LF).getOrDefault({=> -1})) => data.split(Symbols.LF, removeEmpty: true)
            case _ => throw Exception("Invalid toml")
        }
        let element: Element = Element(lines)
        let docMap: HashMap<String, Array<Byte>> = element.parse()
        let docIterator: HashMapIterator<String, Array<Byte>> = docMap.iterator()
        while(true) {
            match(docIterator.next()) {
                case Some((key, value)) => match {
                                                case integerParser.isA(value, key: key) => // do somethings
                                                                                           integerParser.asA(value, key: key)!
                                                case floatParser.isA(value, key: key) => // do somethings
                                                                                         floatParser.asA(value, key: key)!
                                                case booleanParser.isA(value, key: key) => // do somethings
                                                                                           booleanParser.asA(value, key: key)!
                                                case dateTimeParser.isA(value, key: key) => // do somethings
                                                                                            dateTimeParser.asA(value, key: key)!
                                                case stringParser.isA(value, key: key) => // do somethings
                                                                                          stringParser.asA(value, key: key)!
                                                case listParser.isA(value, key: key) => // do somethings
                                                                                        listParser.asA(value, key: key)!
                                                case mapParser.isA(value, key: key) => // do somethings
                                                                                       mapParser.asA(value, key: key)!
                                            }
                case None => break
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