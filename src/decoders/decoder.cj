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
        let lf: String = String.fromUtf8([0x0A])
        let crlf: String = String.fromUtf8([0x0D, 0x0A])
        let lines: Array<String> = match {
            case (0 < data.indexOf(crlf).getOrDefault({ => -1})) => data.split(crlf, removeEmpty: true)
            case (0 < data.indexOf(lf).getOrDefault({=> -1})) => data.split(lf, removeEmpty: true)
            case _ => throw Exception("Invalid toml")
        }
        let element: Element = Element(lines)
        let docMap: HashMap<String, Array<Byte>> = element.parse()
        let docIterator: HashMapIterator<String, Array<Byte>> = docMap.iterator()
        while(true) {
            match(docIterator.next()) {
                case Some((key, value)) => match {
                                                case IntegerParser.isA(value, key: key) => // do somethings
                                                                                           IntegerParser.asA(value, key: key)
                                                case FloatParser.isA(value, key: key) => // do somethings
                                                                                         FloatParser.asA(value, key: key)
                                                case BooleanParser.isA(value, key: key) => // do somethings
                                                                                           BooleanParser.asA(value, key: key)
                                                case DateTimeParser.isA(value, key: key) => // do somethings
                                                                                            DateTimeParser.asA(value, key: key)
                                                case StringParser.isA(value, key: key) => // do somethings
                                                                                          StringParser.asA(value, key: key)
                                                case ListParser.isA(value, key: key) => // do somethings
                                                                                        ListParser.asA(value, key: key)
                                                case MapParser.isA(value, key: key) => // do somethings
                                                                                       MapParser.asA(value, key: key)
                                            }
                case None => break
            }
        }
        // for (item in lines) {
        //     match {
        //         case IntegerParser.isA(line) => // do somethings
        //                                         IntegerParser.asA(line)
        //         case FloatParser.isA(line) => // do somethings
        //                                       FloatParser.asA(line)
        //         case BooleanParser.isA(line) => // do somethings
        //                                         BooleanParser.asA(line)
        //         case DateTimeParser.isA(line) => // do somethings
        //                                          DateTimeParser.asA(line)
        //         case StringParser.isA(line) => // do somethings
        //                                          StringParser.asA(line)
        //         case ListParser.isA(line) => // do somethings
        //                                          ListParser.asA(line)
        //         case MapParser.isA(line) => // do somethings
        //                                          MapParser.asA(line)
        //     }
        // }
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