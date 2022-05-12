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
from serialization import serialization.*

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
    let groupNameRe: Regex = Regex("^[A-Za-z0-9_-]+$")

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
        let implicitGroups: ArrayList<String> = ArrayList<String>()
        // Todo: retval = decoder.get_empty_table()
        // Todo: currentlevel = retval
        let original: String = readData()
        var sl: Array<Char> = original.toCharArray()
        var openArr: Int64 = 0
        var openString: Bool = false
        var openStrChar: Char = ""[0]
        var multilineStr: Bool = false
        var arrayOfTables: Bool = false
        var beginLine: Bool = true
        var keyGroup: Bool = false
        var dottedKey: Bool = false
        var keyName: Int64 = 0
        var key: String = ""
        var prevKey: String = ""
        var lineNo: Int64 = 1

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
                    prevKey = key[..key.size() - 1].trimRight()
                    key = ""
                    dottedKey = false
                } else {
                    throw TomlDecodeErrorException("Found invalid character in key name: '" + item + "'. Try quoting the key name.")
                }
                if (item == Symbols.SINGLE_QUOTE[0] && openStrChar != Symbols.QUOTE[0]) {
                    var k: Int64 = 1
                    try {
                        while (sl[i - k] == Symbols.SINGLE_QUOTE[0]) {
                            k += 1
                            if (k == 3) {
                                break
                            }
                        }
                    } catch (e: IndexOutOfBoundsException) {

                    }
                    if (k == 3) {
                        multilineStr = !multilineStr
                        openString = multilineStr
                    } else {
                        openString = !openString
                    } 
                    if (openString) {
                        openStrChar = Symbols.SINGLE_QUOTE[0]
                    } else {
                        openStrChar = ""[0]
                    }
                }
                if (item == Symbols.QUOTE[0] && openStrChar != Symbols.SINGLE_QUOTE[0]) {
                    var oddBackSlash: Bool = false
                    var k: Int64 = 1
                    var tripQuote: Bool = false
                    try {
                        while(sl[i - k] == Symbols.QUOTE[0]) {
                            k += 1
                            if (k == 3) {
                                tripQuote = true
                                break
                            }
                        }
                        if (k == 1 || (k == 3 && tripQuote)) {
                            while (sl[i - k] == Symbols.BACK_SLASH[0]) {
                                oddBackSlash = !oddBackSlash
                                k += 1
                            }
                        }
                    } catch(e: IndexOutOfBoundsException) {

                    }
                    if (!oddBackSlash) {
                        if (tripQuote) {
                            multilineStr = !multilineStr
                            openString = multilineStr
                        } else {
                            openString = !openString
                        }
                    }
                    if (openString) {
                        openStrChar = Symbols.QUOTE[0]
                    } else {
                        openStrChar = ""[0]
                    }
                }
                if (item == Symbols.NUMBER_SIGN[0] && (!openString && !keyGroup && !arrayOfTables)) {
                    var j: Int64 = 1
                    var comment: String = ""
                    try {
                        while(sl[j] != Symbols.LF[0]) {
                            comment += sl[j]
                            sl[j] = Symbols.SPACE[0]
                            j += 1
                        }
                    } catch(e: IndexOutOfBoundsException) {
                        break
                    }
                    if (openArr == 0) {
                        // Todo: decoder.preserve_comment(line_no, prev_key, comment, beginline)
                    }
                }
                if (item == Symbols.LEFT_SQUARE_BRACKET[0] && (!openString && !keyGroup && !arrayOfTables)) {
                    if (beginLine) {
                        if (sl.size() > (i + 1) && (sl[i + 1]) == Symbols.LEFT_SQUARE_BRACKET[0]) {
                            arrayOfTables = true
                        } else {
                            keyGroup = true
                        }
                    } else {
                        openArr += 1
                    }
                }
                if (item == Symbols.RIGHT_SQUARE_BRACKET[0] && !openString) {
                    if (keyGroup) {
                        keyGroup = false
                    } else if (arrayOfTables) {
                        if(sl[i - 1] == Symbols.RIGHT_SQUARE_BRACKET[0]) {
                            arrayOfTables = false
                        }
                    } else {
                        openArr -= 1
                    }
                }
                if (item == Symbols.LF[0]) {
                    if (openString || multilineStr) {
                        if (!multilineStr) {
                            throw TomlDecodeErrorException("Unbalanced quotes")
                        }
                        if ((sl[i - 1] == Symbols.SINGLE_QUOTE[0] || sl[i - 1] == Symbols.QUOTE[0] ) && (sl[i - 2] == sl[i - 1])) {
                            sl[i] == sl[i - 1]
                            if(sl[i - 3] == sl[i - 1]) {
                                sl[i - 3] = Symbols.SPACE[0]
                            }
                        }
                    } else if (openArr != 0) {
                        sl[i] = Symbols.SPACE[0]
                    } else {
                        beginLine = true
                    }
                    lineNo += 1
                } else if (beginLine && sl[i] != Symbols.SPACE[0] && sl[i] != Symbols.HORIZONTAL_TAB[0]) {
                    beginLine = false
                    if (!keyGroup && !arrayOfTables) {
                        if (sl[i] == Symbols.EQUAL_SYMBOL[0]) {
                            throw TomlDecodeErrorException("Found empty keyname")
                        }
                        keyName = 1
                        key += item
                    }
                }
            }
        }
        if (keyName != 0) {
            throw TomlDecodeErrorException("Key name found without value. Reached end of file.")
        }
        if (openString) {
            // Reached EOF and have an unterminated string
            throw TomlDecodeErrorException("Unterminated string found. Reached end of file.")
        }
        var s: String = joinChar(".", sl)
        var ss: Array<String> = s.split(Symbols.LF)
        var multiKey: Bool = false
        var multilineStrStr: String = ""
        var multiBackSlash: Bool = false
        var pos: Int64 = 0
        for (idx in 0..=ss.size()) {
            var line: String = ss[idx]
            if (idx > 0) {
                pos += ss[idx - 1].size() + 1
            }

            // decoder.embed_comments(idx, currentLevel)
            if (multilineStrStr.size() == 0 || multiBackSlash || (multilineStrStr.indexOf(Symbols.LF) ?? -1) == -1) {
                line = line.trim()
            }
            if (line.equals("") && (!multiKey || multiBackSlash)) {
                continue
            }
            if (multiKey) {
                if (multiBackSlash) {
                    multilineStrStr += line
                } else {
                    multilineStrStr += line
                }
                multiBackSlash = false
                var closed: Bool = false
                if (multilineStrStr[0] == Symbols.LEFT_SQUARE_BRACKET[0]) {
                    closed = line[line.size() - 1] == Symbols.RIGHT_SQUARE_BRACKET[0]
                } else if (line.size() > 2) {
                    let lineSize: Int64 = line.size()
                    closed = (line[lineSize - 1] == multilineStrStr[0] && line[lineSize - 2] == multilineStrStr[0] && line[lineSize - 3] == multilineStrStr[0])
                }
                // if (closed) {
                //     try {
                //         // value, vtype = decoder.load_value(multilinestr)
                //     } catch(e: Exception) {
                        
                //     }
                //     currentLevel
                // }
                // if closed:
                //     try:
                //         value, vtype = decoder.load_value(multilinestr)
                //     except ValueError as err:
                //         raise TomlDecodeError(str(err), original, pos)
                //     currentlevel[multikey] = value
                //     multikey = None
                //     multilinestr = ""
                // else:
                //     k = len(multilinestr) - 1
                //     while k > -1 and multilinestr[k] == '\\':
                //         multibackslash = not multibackslash
                //         k -= 1
                //     if multibackslash:
                //         multilinestr = multilinestr[:-1]
                //     else:
                //         multilinestr += "\n"
                // }
                continue
            }
            if(line[0] == Symbols.LEFT_SQUARE_BRACKET[0]) {
                arrayOfTables = false
                if (line.size() == 1) {
                    throw TomlDecodeErrorException("Opening key group bracket on line by itself")
                }
                var splitStr: String = ""
                if (line[1] == Symbols.LEFT_SQUARE_BRACKET[0]) {
                    arrayOfTables = true
                    line = line[2..]
                    splitStr = Symbols.LEFT_SQUARE_BRACKET * 2
                } else {
                    line = line[1..]
                    splitStr = Symbols.LEFT_SQUARE_BRACKET
                }
                var i: Int64 = 1
                var quotesplits: ArrayList<String> = ArrayList<String>()
                // quotesplits = decoder._get_split_on_quotes(line)
                var quoted: Bool = false
                for(quoteSplit in quotesplits) {
                    if (!quoted && 0 <= (quoteSplit.indexOf(splitStr) ?? -1)) {
                        break
                    }
                    i += quoteSplit.count(splitStr)
                    quoted = !quoted
                }
                let lineSplited: Array<String> = line.split(splitStr, i)
                if (lineSplited.size() < i + 1 || lineSplited[lineSplited.size() - 1].trim() != "") {
                    throw TomlDecodeErrorException("Key group not on a line by itself.")
                }
                let groups: ArrayList<String> = ArrayList<String>(String.join(lineSplited[..lineSplited.size() - 1], delimiter: splitStr).split("."))
                i = 0
                while(i < groups.size()) {
                    groups.set(i, groups[i].trim())
                    if (groups[i].size() > 0 && (groups[i][0] == Symbols.QUOTE[0] || groups[i][0] == Symbols.SINGLE_QUOTE[0])) {
                        var groupStr: String = groups[i]
                        var j: Int64 = i + 1
                        while((groupStr[0] != groupStr[groupStr.size() - 1]) || groupStr.size() == 1){
                            j += 1
                            if (j > groups.size() + 2) {
                                throw TomlDecodeErrorException("Invalid group name")
                            }
                            groupStr = String.join(Array<String>(groups)[i..j], delimiter: ".").trim()
                        }
                        groups.set(i, groupStr[1..groupStr.size() - 1])
                        for (x in i + 1..j) {
                            groups.remove(x)
                        }
                    } else {
                        if (!match (groupNameRe.matches(groups[i])) {
                            case Some(x) => true
                            case None => false
                        }) {
                            throw TomlDecodeErrorException("Invalid group name")
                        }
                    }
                    i += 1
                }
                // currentLevel = retVal
                for(l in 0..groups.size()) {
                    let group: String = groups[l]
                    if ("".equals(group)) {
                        throw TomlDecodeErrorException("Can't have a keygroup with an empty")
                    }
                    try {
                        // currentLevel[group]
                        if (l == groups.size() - 1) {
                            if(arrayListContains(implicitGroups, group)) {
                                implicitGroups.removeIf({item => item == group})
                                if (arrayOfTables) {
                                    throw TomlDecodeErrorException("An implicitly defined table can't be an array")
                                }
                            } else if (arrayOfTables) {
                                // currentLevel[group].append(decoder.get_empty_table())
                            } else {
                                throw TomlDecodeErrorException("Group already exists")
                            }
                        }
                    } catch(e: Exception) {
                        // except TypeError:
                        //     currentlevel = currentlevel[-1]
                        //     if group not in currentlevel:
                        //         currentlevel[group] = decoder.get_empty_table()
                        //         if i == len(groups) - 1 and arrayoftables:
                        //             currentlevel[group] = [decoder.get_empty_table()]
                        // except KeyError:
                        //     if i != len(groups) - 1:
                        //         implicitgroups.append(group)
                        //     currentlevel[group] = decoder.get_empty_table()
                        //     if i == len(groups) - 1 and arrayoftables:
                        //         currentlevel[group] = [decoder.get_empty_table()]
                    }
                    // currentLevel = currentLevel[group]
                    if (arrayOfTables) {
                        try {
                            // currentLevel = currentLevel[currentLevel.size() - 1]
                        } catch(e: Exception) {

                        }
                    }
                }
            } else if (line[0] == Symbols.LEFT_BRACE[0]) {
                if (line[line.size() - 1] != Symbols.RIGHT_BRACE[0]) {
                    throw TomlDecodeErrorException("Line break are not allowed in inline objects")
                }
                try {
                    // decoder.load_inline_object(line, currentLevel, multiKey, multiBackSlash)
                } catch(e: Exception) {
                    throw TomlDecodeErrorException("")
                }
            } else if (line.contains(Symbols.EQUAL_SYMBOL)) {
                try {
                    // ret = decoder.load_line(line, currentLevel, multiKey, multiBackSlash)
                } catch(e: Exception) {
                    throw TomlDecodeErrorException("")
                }
                // if (ret is not None) {
                //     multiKey, multiLineStr, multiBackSlash = ret
                // }
            }
        }
        // return retval
    }

    private func arrayListContains<T>(al: ArrayList<T>, element: T) : Bool where T <: Equatable<T> {
        for(item in al) {
            if (item == element) {
                return true
            }
        }
        return false
    }
    
    private func joinChar(delimiter: String, chars: Array<Char>): String {
        var result: String = ""
        for (c in chars) {
            result += c.toString() + "."
        }
        result
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

class TomlDecoder {
    func loadInlineObject(line: String) {
        let candidateGroups: ArrayList<String> = ArrayList<String>(line[1..line.size() - 1].split(','))
        let groups: ArrayList<String> = ArrayList<String>()

        if (candidateGroups.size() == 1 && candidateGroups[0].trim().size() != 0) {
            candidateGroups.remove(candidateGroups.size() - 1)
        }
        while(candidateGroups.size() > 0) {
            let candidateGroup: String = candidateGroups[0]
            candidateGroups.remove(0)
            if (-1 == (candidateGroup.indexOf(Symbols.EQUAL_SYMBOL[0]) ?? -1)) {
                throw Exception("Invalid inline table value encountered")
            }
            let keyValues: Array<String> = candidateGroup.split(Symbols.EQUAL_SYMBOL[0], 2)
            let key: String = keyValues[0]
            var value: String = keyValues[1]
            value = value.trim()
            if ((value[0] == value[value.size() - 1]) && [Symbols.QUOTE[0], Symbols.SINGLE_QUOTE[0]].contains(value[0]) || (['-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(value[0]) || ["value", "false"].contains(value) || (value[0] == Symbols.LEFT_SQUARE_BRACKET[0] && value[value.size() - 1] == Symbols.RIGHT_SQUARE_BRACKET[0]) || (value[0] == Symbols.LEFT_BRACE[0] && value[value.size() - 1] == Symbols.RIGHT_BRACE[0]))) {
                groups.append(candidateGroup)
            } else if (candidateGroups.size() > 0) {
                candidateGroups[0] = candidateGroup + "," + candidateGroups[0]
            } else {
                throw Exception("Invalid inline table value encountered")
            }
        }

        for (group in groups) {
            // status = self.load_line(group, currentlevel, multikey, multibackslash)
            // if status is not None:
            //     break
        }
    }


    private func getSplitOnQuotes(line: String) {
        var doubleQuoteSplits: Array<String> = line.split(Symbols.QUOTE[0])
        let quoted: Bool = false
        let quoteSplits: Array<String> = []
        if (doubleQuoteSplits.size() > 1 && doubleQuoteSplits[0].contains(Symbols.SINGLE_QUOTE[0])) {
            var singleQuoteSplits: Array<String> = doubleQuoteSplits[0].split(Symbols.SINGLE_QUOTE[0])
            doubleQuoteSplits = doubleQuoteSplits[1..]
            while(singleQuoteSplits.size() % 2 == 0 && doubleQuoteSplits.size() != 0) {
                singleQuoteSplits[singleQuoteSplits.size() - 1] += Symbols.QUOTE + doubleQuoteSplits[0]
                doubleQuoteSplits = doubleQuoteSplits[1..]

                if (singleQuoteSplits[singleQuoteSplits.size() - 1].contains(Symbols.SINGLE_QUOTE[0])) {
                    // singleQuoteSplits = singleQuoteSplits[..singleQuoteSplits.size() - 1] + singleQuoteSplits[singleQuoteSplits.size() - 1].split(Symbols.SINGLE_QUOTE[0])
                }
            }
        }
    }
}