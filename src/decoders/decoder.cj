/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about Decoding various data types
 */

package decoders

from std import io.*
from std import collection.*
from std import regex.*
from std import unicode.*
from serialization import serialization.*
from std import convert.*
from std import time.*
from encoding import json.*

//type element = HashMap<Key, Value>

/**
 * The class is Decoder
 * @author Annlix
 * @since 0.28.4
 */
public class Decoder {
    var stream: Option<Stream> = None
    var data: Option<String> = None
    var mode: DecodeMode = DecodeMode.UNSPECIFIED
    //static let booleanParser: BooleanParser = BooleanParser()
    //static let integerParser: IntegerParser = IntegerParser()
    // static let dateTimeParser: DateTimeParser = DateTimeParser()
    // static let floatParser: FloatParser = FloatParser()
    // static let listParser: ListParser = ListParser()
    // static let mapParser: MapParser = MapParser()
    // static let stringParser: StringParser = StringParser()
    static let DEFAULT_BUFFER_SIZE = 2 << 11  // 4096
    let groupNameRe: Regex = Regex("^[A-Za-z0-9_-]+$")

    /**
     * The Function is init constructor
     *
     * @since 0.28.4
     */
    public init() {
    }

    /**
     * The Function is load
     *
     * @param pn of String, file path
     *
     * @since 0.28.4
     */
    public func load(pn: String) {
        load(FileStream(pn))
    }

    /**
     * The Function is load
     *
     * @param file of FileStream
     *
     * @since 0.28.4
     */
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

    /**
     * The Function is decode
     *
     * @since 0.28.4
     */
    public func decode():JsonObject {
        let implicitGroups: ArrayList<String> = ArrayList<String>()
        let original: String = readData()
        var sl: Array<Char> = original.toCharArray()
        var openArr: Int64 = 0
        var openString: Bool = false
        var openStrChar: Char = '0'
        var multilineStr: Bool = false
        var arrayOfTables: Bool = false
        var beginLine: Bool = true
        var keyGroup: Bool = false
        var dottedKey: Bool = false
        var keyName: Int64 = 0
        var key: String = ""
        var prevKey: String = ""
        var lineNo: Int64 = 1
        let jsons: JsonObject = JsonObject()  // json_return
        var subjo: JsonValue = jsons
        let nilJson: JsonValue = JsonObject()
        for (i in 0..sl.size()) {
            let item: Char = sl[i]
            if(item == Symbols.CR[0] && sl[i + 1] == Symbols.LF[0]) {
                sl[i] = chr(0x20) // ' '
                continue
            }
            if (0 != keyName) {
                key += item
                if (item == '\n') {
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
                            openStrChar = '0'
                        }
                    }
                    continue
                }
                else if(keyName == 1) {
                    if (item.isAsciiWhiteSpace()) {
                        keyName = 2
                        continue
                    } else if (item == Symbols.DOT[0]) {
                        dottedKey = true
                        continue
                    } else if ((item.isAsciiLetter() || item.isAsciiNumber()) || item == '_' || item == '-') {
                        continue
                    } else if (dottedKey && sl[i - 1] == Symbols.DOT[0] && (item == Symbols.QUOTE[0] || item == Symbols.SINGLE_QUOTE[0])) {
                        openString = true
                        openStrChar = item
                        continue
                    }
                }
                else if (keyName == 2) {
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
                if (item == '=') {
                    keyName = 0
                    prevKey = key[..key.size() - 1].trimRight()
                    key = ""
                    dottedKey = false
                }
                else {
                    throw TomlDecodeErrorException("Found invalid character in key name: '" + item + "' Try quoting the key name.")
                }

            }
            if (item == '\'' && openStrChar != '"') {
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
                    openStrChar = '0'
                }
            }
            if (item == '"' && openStrChar != '\'') {
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
                    openStrChar = '0'
                }
            }
            if (item == '#' && (!openString && !keyGroup && !arrayOfTables)) {
                var j: Int64 = i
                var comment: String = ""
                try {
                    while(sl[j] != '\n') {
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
            }
            else if (beginLine && sl[i] != ' ' && sl[i] != '\t') {
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
        if (keyName != 0) {
            throw TomlDecodeErrorException("Key name found without value. Reached end of file.")
        }
        if (openString) {
            // Reached EOF and have an unterminated string
            throw TomlDecodeErrorException("Unterminated string found. Reached end of file.")
        }
        var s: String = joinChar(sl)
        var ss: Array<String> = s.split(Symbols.LF)
        var multiKey: Bool = false
        var multilineStrStr: String = ""
        var multiBackSlash: Bool = false
        var pos: Int64 = 0
        for (idx in 0..ss.size()) {
            var line: String = ss[idx].trim()
            if (line.isEmpty()) {
                continue
            }
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
                    closed = (line[lineSize - 1] == multilineStrStr[0] &&
                                line[lineSize - 2] == multilineStrStr[0] &&
                                line[lineSize - 3] == multilineStrStr[0])
                }
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
                    splitStr = "]]"
                } else {
                    line = line[1..]
                    splitStr = Symbols.RIGHT_SQUARE_BRACKET
                }
                var i: Int64 = 1
                var quotesplits: ArrayList<String> = ArrayList<String>()
                var quoted: Bool = false
                for(quoteSplit in quotesplits) {
                    if (!quoted && 0 <= (quoteSplit.indexOf(splitStr) ?? -1)) {
                        break
                    }
                    i += quoteSplit.count(splitStr)
                    quoted = !quoted
                }
                let lineSplited: Array<String> = line.split(splitStr)
                if (lineSplited.size() < i + 1 || lineSplited[lineSplited.size() - 1].trim() != "") {
                    throw TomlDecodeErrorException("Key group not on a line by itself.")
                }
                let groups: ArrayList<String> = ArrayList<String>(String.join(lineSplited[..lineSplited.size() - 1], delimiter: splitStr).split("."))
                for (index in groups.size()-1..=0:-1) {
                    if (groups[index].equals("")) {
                        groups.remove(index)
                    }
                }
                i = 0

                        /// group
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
                for(l in 0..groups.size()) {
                    let group: String = groups[l]
                    if ("".equals(group)) {
                        throw TomlDecodeErrorException("Can't have a keygroup with an empty")
                    }
                    try {
                        subjo.asObject().getOrThrow().get(group)
                        if (l == groups.size() - 1) {
                            if(arrayListContains(implicitGroups, group)) {
                                implicitGroups.removeIf({item => item == group})
                                if (arrayOfTables) {
                                    throw TomlDecodeErrorException("todo, An implicitly defined table can't be an array")
                                }
                            } else if (arrayOfTables) {
                                // currentLevel[group].append(decoder.get_empty_table())
                            } else {
                                throw TomlDecodeErrorException("Group already exists")
                            }
                        }
                    } catch(e: Exception) {
                        if (e.toString().contains("JsonException:")) {
                            if (i != groups.size()-1) {
                                implicitGroups.add(group)
                            }
                            subjo.asObject().getOrThrow().put(group, nilJson)
                            if ((i == groups.size() - 1) && arrayOfTables) {
                                // add array
                            }
                        } else {
                            throw Exception("${e.toString()}")
                        }
                    }
                    subjo = subjo.asObject().getOrThrow().get(group)
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
                    throw TomlDecodeErrorException("")
                } catch(e: Exception) {
                    throw TomlDecodeErrorException("")
                }
            } else if (line.contains(Symbols.EQUAL_SYMBOL)) {
                try {
                    let (k,v) = loadLine(line)
                    subjo.asObject().getOrThrow().put(k, JsonString(v))
                } catch(e: Exception) {
                    throw TomlDecodeErrorException("")
                }
                // if (ret is not None) {
                //     multiKey, multiLineStr, multiBackSlash = ret
                // }
            }
        }
        return jsons
    }

    private func loadLine(line: String):String*String {
        let kv = line.split('=')
        return (kv[0].trim(), kv[1].trim())
    }

    private func arrayListContains<T>(al: ArrayList<T>, element: T) : Bool where T <: Equatable<T> {
        for(item in al) {
            if (item == element) {
                return true
            }
        }
        return false
    }
    
    private func joinChar(chars: Array<Char>): String {
        var result: String = ""
        for (c in chars) {
            result += c.toString()
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
                                case Some(d) => d
                                case _ => throw Exception("Must specify the data")
                           }
            case _ => throw Exception("Must specify the data source first")
        }
        data   
    }

    private func loadValue(vs: String, strictlyValid!: Bool = true): String {
        var v: String = vs
        if (v.isEmpty()) {
            throw Exception()
        }
        if (v.equals("true")) {
            return true.toString()
        } else if (v.toLower() == "true") {
            throw Exception()
        } else if (v.equals("false")) {
            return false.toString()
        } else if (v.toLower() == "false") {
            throw Exception()
        } else if (v[0] == '"' || v[0] == '\'') {
            let quotechar = v[0]
            var testv = v[1..].split(quotechar)
            var triplequolte = false
            var triplequoltecount = 0
            if (testv.size() > 1 && testv[0] == "" && testv[1] == "") {
                testv = testv[2..]
                triplequolte = true
            }
            var closed = false
            for (tv in testv) {
                if (tv == "") {
                    if (triplequolte) {
                        triplequoltecount += 1
                    } else {
                        closed = true
                    }
                } else {
                    var oddbackslash = false
                    try {
                        var i = tv.size() - 1
                        var j = tv[i]
                        while (j == '\\') {
                            oddbackslash = !oddbackslash
                            i--
                            j = tv[i]
                        }
                    } catch (e: Exception) {
                        continue
                    }
                    if (!oddbackslash) {
                        if (closed) {
                            throw Exception()
                        } else {
                            if (!triplequolte || triplequoltecount > 1) {
                                closed = true
                            } else {
                                triplequoltecount = 0
                            }
                        }

                    }
                }
            }
            if (quotechar == '"') {
                var escapeseqs = v.split('\\')[1..]
                var backslash = false
                for (i in escapeseqs) {
                    if (i == "") {
                        backslash = !backslash
                    } else {
                        if (!getInchars(i[0]) && i[0] != 'u' && i[0] != 'U' && !backslash) {
                            throw Exception()
                        }
                        if (backslash) {
                            backslash = false
                        }
                    }
                }
                for ( prefix in ["\\u", "\\U"]) {
                    if (v.contains(prefix)) {
                        let hexbytes = v.split(prefix)
                        v = load_unicode_escapes(hexbytes[0], hexbytes[1..], prefix)
                    }
                }
                v = unescape(v)
            }
            if (v.size() > 1 && v[1] == quotechar && (v.size() < 3 || v[1] == v[2])) {
                v = v[2..v.size() - 2]
            }
            return v[1 .. v.size()-1]
        } else if (v[0] == '[') {
            throw Exception(" not support")
        } else if (v[0] == '{'){
            throw Exception(" not support")
        } else {
            return v
        }
    }

    private func load_unicode_escapes(v: String, hexbytes: Array<String>, prefix: String): String {
        return v
    }
    private let mypsbs = ['0', 'b', 'f', 'n', 'r', 't', '"']
    private func getInchars(c: Char): Bool {
        for (m in mypsbs) {
            if (c == m) {
                return true
            }
        }
        return false
    }
    private func unescape(vs: String): String {
        var v = vs
        var i : Int64 = 0
        var backslash = false
        while (i < v.size()) {
            if (backslash){
                backslash = false
                if (getInchars(v[i])) {
                    v = v[0..i-1] + v[i] + v[i+1..]
                } else if (v[i] == '\\') {
                    v = v[..i-1] + v[i..]
                } else if (v[i] == 'u' || v[i] == 'U') {
                    i +=1
                } else {
                    throw Exception()
                }
                continue
            } else if (v[i] == '\\') {
                backslash = true
            }
            i++
        }
        return v
    }
}
