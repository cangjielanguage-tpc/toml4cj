/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about Decoding various data types
 */

package decoders

from std import fs.*
from std import io.InputStream
from std import collection.*
from std import regex.*
from std import unicode.*
from serialization import serialization.*
from std import convert.*
from std import time.*
from encoding import json.*

enum DecodeMode {
    | UNSPECIFIED
    | STREAM
    | STRING
}

/**
 * The class is Decoder
 * @author Annlix
 * @since 0.28.4
 */
public class Decoder {
    /* var member stream type is Option<Stream> */
    var stream: ?InputStream = None
    var data: ?String = None
    var mode: DecodeMode = DecodeMode.UNSPECIFIED
    static let DEFAULT_BUFFER_SIZE = 2 << 11  // 4096
    private let groupNameRe: Regex = Regex("^[A-Za-z0-9_-]+$")

    private let numberWithUnderScores: Regex = Regex("([0-9])(_([0-9]))*")

    private let TIME_RE: Regex = Regex("([0-9]{2}):([0-9]{2}):([0-9]{2})(\\.([0-9]{3,6}))?")

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
        let arr = pn.split("/")
        if (!arr[arr.size - 1].contains(".") || arr[arr.size - 1].size == 0) {
            throw IllegalArgumentException("The format of the file is not supported.")
        }
        load(File.openRead(pn))
    }
    /**
     * The Function is load
     *
     * @param file of FileStream
     *
     * @since 0.28.4
     */
    public func load(file: File) {
        match(data) {
            case Some(_) => throw Exception("Can't use string decode and stream decode at the same time")
            case None => ()
        }
        mode = DecodeMode.STREAM
        if(!file.canRead()) { throw Exception("Open file failed") }
        if (!file.info.path.fileName.getOrThrow().endsWith(".toml")) {
            throw IllegalArgumentException("The format of the file is not supported.")
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
        let jsons: JsonObject = JsonObject()
        var subjo: JsonValue = jsons
        for (i in 0..sl.size) {
            let item: Char = sl[i]
            if(item == Symbols.CR[0] && sl[i + 1] == Symbols.LF[0]) {
                sl[i] = Char(0x20)
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
                    } else if (dottedKey && sl[i - 1] == '.' && (item == '\"' || item == '\'')) {
                        openString = true
                        openStrChar = item
                        continue
                    }
                }
                else if (keyName == 2) {
                    if (item.isAsciiWhiteSpace()) {
                        if (dottedKey) {
                            let nextItem: Char = sl[i + 1]
                            if (!nextItem.isAsciiWhiteSpace() && nextItem != '.') {
                                keyName = 1
                            }
                        }
                        continue
                    }
                    if (item == '.') {
                        dottedKey = true
                        let nextItem: Char = sl[i + 1]
                        if (!nextItem.isAsciiWhiteSpace() && nextItem != '.') {
                            keyName = 1
                        }
                        continue
                    }
                }
                if (item == '=') {
                    keyName = 0
                    prevKey = key[..key.size - 1].trimRight()
                    key = ""
                    dottedKey = false
                }
                else {
                    let err: String="Found invalid character in key name: '${item}' Try quoting the key name. i = ${i}"
                    throw TomlDecodeErrorException(err)
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
                    ()
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
            if (item == '\"' && openStrChar != '\'') {
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
                    ()
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
                    if (sl.size > (i + 1) && (sl[i + 1]) == Symbols.LEFT_SQUARE_BRACKET[0]) { // [
                        arrayOfTables = true
                    } else {
                        keyGroup = true
                    }
                } else {
                    openArr += 1
                }
            }
            if (item == Symbols.RIGHT_SQUARE_BRACKET[0] && !openString) { // ]
                if (keyGroup) {
                    keyGroup = false
                } else if (arrayOfTables) {
                    if (sl[i - 1] == ']') { arrayOfTables = false }
                } else {
                    openArr -= 1
                }
            }
            if (item == Symbols.LF[0]) {// \n
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
                    sl[i] = ' '
                } else {
                    beginLine = true
                }
                lineNo += 1
            }
            else if (beginLine && sl[i] != ' ' && sl[i] != '\t') {
                beginLine = false
                if (!keyGroup && !arrayOfTables) {
                    if (sl[i] == '=') { throw TomlDecodeErrorException("Found empty keyName. ${original}, i = ${i}") }
                    keyName = 1
                    key += item
                }
            }
        }
        var s: String = String(sl)

        var ss: Array<String> = s.split(Symbols.LF)
        var multiKey: Bool = false
        var multilineStrStr: String = ""
        var multiBackSlash: Bool = false
        var pos: Int64 = 0
        for (idx in 0..ss.size) {
            var line: String = ss[idx].trim()

            if (line.isEmpty()) {
                continue
            }
            if (idx > 0) {
                pos += ss[idx - 1].size + 1
            }
            if (multilineStrStr.size == 0 || multiBackSlash || (multilineStrStr.indexOf(Symbols.LF) ?? -1) == -1) {// \n
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
                if (multilineStrStr[0] == '[') {
                    closed = line[line.size - 1] == ']'
                } else if (line.size > 2) {
                    closed = (line[line.size - 1] == multilineStrStr[0] &&
                              line[line.size - 2] == multilineStrStr[0] &&
                              line[line.size - 3] == multilineStrStr[0])
                }
                if (closed) {
                    var value: ArrayList<String> = ArrayList<String>()
                    var vtype: String = ""
                    try {
                        let res: (ArrayList<String>, String) = loadValue(multilineStrStr)
                        value = res[0]
                        vtype = res[1]
                    } catch (e: Exception) {
                        throw TomlDecodeErrorException("${e.message}. ${original}, pos = ${pos}")
                    }
                    if (vtype.equals("array")) {
                        let ja: JsonArray = JsonArray()
                        for (str in value) {
                            ja.add(JsonValue.fromStr(str))
                        }
                        subjo.asObject().put(multiKey.toString(), ja)
                    } else {
                        subjo.asObject().put(multiKey.toString(), JsonValue.fromStr(value[0]))
                    }

                    multiKey = false
                    multilineStrStr = ""
                } else {
                    var k: Int64 = multilineStrStr.size - 1
                    while (k > -1 && multilineStrStr[k] == '\\') {
                        multiBackSlash = !multiBackSlash
                        k -= 1
                    }
                    if (multiBackSlash) {
                        multilineStrStr = multilineStrStr.slice(0, multilineStrStr.size - 1)
                    } else {
                        multilineStrStr += "\n"
                    }
                }
                continue
            }

            if(line[0] == '[') {
                arrayOfTables = false
                if (line.size == 1) {
                    throw TomlDecodeErrorException("Opening key group bracket on line by itself")
                }
                var splitStr: String = ""
                if (line[1] == Symbols.LEFT_SQUARE_BRACKET[0]) {// [
                    arrayOfTables = true
                    line = line.slice(2, line.size-2)
                    splitStr = "]]"
                } else {
                    line = line.slice(1, line.size-1)
                    splitStr = Symbols.RIGHT_SQUARE_BRACKET // ]
                }
                var i: Int64 = 1

                var quotesplits: ArrayList<String> = (getSplitOnQuotes(line) as ArrayList<String>).getOrThrow()

                var quoted: Bool = false

                for (quotesplit in quotesplits) {
                    if (!quoted && quotesplit.contains(splitStr)) {
                        break
                    }
                    i += quotesplit.count(splitStr)
                    quoted = !quoted
                }

                let lineSplited: Array<String> = line.split(splitStr)

                if (lineSplited.size < i + 1 || lineSplited[lineSplited.size - 1].trim() != "") {
                    throw TomlDecodeErrorException("Key group not on a line by itself.")
                }
                let groups: ArrayList<String> = ArrayList<String>(String.join(lineSplited.slice(0, lineSplited.size-1), delimiter: splitStr).split("."))

                for (index in groups.size-1..=0:-1) {
                    if (groups[index].equals("")) { groups.remove(index) }
                }

                i = 0
                while(i < groups.size) {
                    groups.set(i, groups[i].trim())
                    if (groups[i].size > 0 && (groups[i][0] == Symbols.QUOTE[0] || groups[i][0] == Symbols.SINGLE_QUOTE[0])) {

                        var groupStr: String = groups[i]
                        var j: Int64 = i + 1
                        while (!(groupStr[0] == groupStr[groupStr.size - 1]) || groupStr.size == 1) {
                            j += 1
                            if (j > groups.size + 2) {
                                let err = "Invalid group name '${groupStr}' Something went wrong. pos = ${pos}.\n" +
                                        original
                                throw TomlDecodeErrorException(err)
                            }
                            groupStr = String.join(groups.slice(i..j).toArray(), delimiter: ".").trim()
                        }
                        groups[i] = groupStr.slice(1, groupStr.size - 2)
                    } else {
                        if (!match (groupNameRe.matches(groups[i])) {
                            case None => false
                            case Some(_) => true
                        }) {
                            let err = "Invalid group name '${groups[i]}'. Try quoting it. pos = ${pos}.\n ${original}"
                            throw TomlDecodeErrorException(err)
                        }
                    }
                    i += 1
                }

                subjo = jsons
                for(l in 0..groups.size) {
                    let group: String = groups[l]
                    if ("".equals(group)) { throw TomlDecodeErrorException("Can't have a keygroup with an empty") }
                    try {
                        subjo.asObject().get(group).getOrThrow()
                        if (l == groups.size - 1) {
                            if (arrayListContains(implicitGroups, group)) {
                                implicitGroups.removeIf({item => item == group})
                                if (arrayOfTables) {
                                    let err="An implicitly defined table can't be an array. pos = ${pos}.\n ${original}"
                                    throw TomlDecodeErrorException(err)
                                }
                            } else if (arrayOfTables) {
                                subjo.asObject().get(group).getOrThrow().asObject().put(group, getEmptyTable())
                            } else {
                                let err="What? ${group} already exists? ${subjo.toString()}. pos = ${pos}.\n" + original
                                throw TomlDecodeErrorException(err)
                            }
                        }
                    } catch(e: Exception) {
                        if (i != (groups.size - 1)) {
                            implicitGroups.append(group)
                        }

                        subjo.asObject().put(group, getEmptyTable())
                        if (i == groups.size - 1 && arrayOfTables) {
                            subjo.asObject().put(group, JsonArray(Array<JsonValue>([getEmptyTable()])) )
                        }

                    }
                    subjo = subjo.asObject().get(group).getOrThrow()
                }
            }
            else if (line.contains('=')) {
                loadLine(subjo.asObject(), line, multilineStrStr, multiBackSlash)
            }
        }
        return jsons
    }

    private func getEmptyTable(): JsonValue {
        return JsonObject()
    }

    /*
     * The Function is loadLineMultilineStr
     *
     * @param pstr of String)
     * @param String) of (Int64,Int64
     *
     * @since 0.29.3
     */
    private func loadLineMultilineStr(pstr: String): (Int64, Int64){
        var p: String = pstr
        var poffset: Int64 = 0
        if (p.size < 3) {
            return (-1, poffset)
        }

        if (p[0] == '[' && (p.trim()[p.size-1] != ']' && loadArrayIsstrarray(p))) {
            var newp: Array<String> = p.slice(1, p.size - 1).trim().split(',')
            while (newp.size > 1 && newp[-1][0] != '"' && newp[-1][0] != '\'') {
                let strLast: String = newp[newp.size - 2] + ',' + newp[newp.size - 1]
                newp = newp.slice(0, newp.size - 1)
                newp[newp.size - 1] = strLast
            }
            let newpStr: String = newp[newp.size - 1]
            poffset = p.size - newpStr.size
            p = newpStr
        }

        if (p[0] != '"' && p[0] != '\'') {
            return (-1, poffset)
        }
        if (p[1] != p[0] || p[2] != p[0]) {
            return (-1, poffset)
        }
        if (p.size > 5 && p[p.size-1] == p[0] && p[p.size-2] == p[0] && p[p.size-3] == p[0] ) {
            return (-1, poffset)
        }
        return (p.size-1, poffset)
    }
    
    /*
     * The Function is arrayListContains<T>
     *
     * @param al of ArrayList<T>
     * @param element of T
     *
     * @return Type of Bool where T <: Equatable<T>
     * @since 0.29.3
     */
    private func arrayListContains<T>(al: ArrayList<T>, element: T) : Bool where T <: Equatable<T> {
        for(item in al) {
            if (item == element) {
                return true
            }
        }
        return false
    }
    
    /*
     * The Function is joinChar
     *
     * @param chars of Array<Char>
     *
     * @return Type of String
     * @since 0.29.3
     */
    private func joinChar(chars: Array<Char>): String {
        var result: String = ""
        for (c in chars) {
            result += c.toString()
        }
        result
    }
    
    /*
     * The Function is loadValue
     *
     * @param vs of String
     * @param strictlyValid of Bool, and the Default value is true
     *
     * @return Type of String
     * @since 0.29.3
     */
    private func loadValue(vs: String): (ArrayList<String>, String) {
        var v: String = vs
        let results: ArrayList<String> = ArrayList<String>()
        if (v.isEmpty()) {
            throw Exception("Empty value is invalid")
        }
        if (v.equals("true")) {
            results.append("true")
            return (results, "Bool")
        }
        else if (v.toLower() == "true") {
            throw Exception("Only all lowercase booleans allowed")
        }
        else if (v.equals("false")) {
            results.append("false")
            return (results, "Bool")
        }
        else if (v.toLower() == "false") {
            throw Exception("Only all lowercase booleans allowed!")
        }
        else if (v[0] == '\"' || v[0] == '\'') {
            let quotechar = v[0]
            var testv = v[1..].split(quotechar)
            var triplequolte = false
            var triplequoltecount = 0
            if (testv.size > 1 && testv[0] == "" && testv[1] == "") {
                testv = if (testv.size > 2) {
                    testv[2..]
                } else {
                    Array<String>()
                }
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
                        var i = tv.size - 1
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
                            throw Exception("Found tokens after a closed string. Invalid TOML.")
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
                var escapeseqs = if (v.contains('\\')) {
                    v.split('\\')[1..]
                } else {
                    Array<String>()
                }
                var backslash = false
                for (i in escapeseqs) {
                    if (i == "") {
                        backslash = !backslash
                    } else {
                        if (!getInchars(i[0]) && i[0] != 'u' && i[0] != 'U' && !backslash) {
                            throw Exception()
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
            if (v.size > 1 && v[1] == quotechar && (v.size < 3 || v[1] == v[2])) {
                v = v[2..v.size - 2]
            }
            results.append(v[1 .. v.size-1])
            return (results, "str")
        }
        else if (v[0] == '[') {
            return (loadArray(v), "array")
        } else if (v[0] == '{'){
            let inlineObj = JsonObject()
            loadInlineObject(v, inlineObj)
            results.append(inlineObj.toString())
            return (results, "inline_object")
        } else {
            results.append(v)
            return (results, "others")
        }
    }

    func boundedString(s: String): Bool {
        if (s.size == 0) {
            return true
        }
        if (s[s.size - 1] != s[0]) {
            return false
        }
        var i: Int64 = -2
        var backslash: Bool = false
        while (s.size + i > 0) {
            if (s[s.size + i] == '\\') {
                backslash = !backslash
                i -= 1
            } else {
                break
            }
        }
        return !backslash
    }

    func loadArrayIsstrarray(strArray: String): Bool {
        let str: String = strArray.slice(1, strArray.size - 2).trim()
        if (!str.isEmpty() && (str[0] == '"' || str[0] == '\'')) {
            return true
        }
        return false
    }

    func loadArray(str: String): ArrayList<String> {
        var atype: String = ""
        var retval: ArrayList<String> = ArrayList<String>()
        var a: String = str.trim()
        var aArray: ArrayList<String> = ArrayList<String>()
        let str1_1: String = a.slice(1, a.size - 2)
        if (!str1_1.contains("[") || !str1_1.split('[')[0].trim().equals("")) {
            let strArray: Bool = loadArrayIsstrarray(a)
            if (!str1_1.trim().startsWith("{")) {
                aArray.appendAll(str1_1.split(','))
            } else {
                // a is an inline object, and we must find matching parentheses to define the group
                let new_a: ArrayList<String> = ArrayList<String>()
                var start_group_index: Int64 = 1
                var end_group_index: Int64 = 2
                var open_bracket_count: Int64 = 0

                if (a[start_group_index] == '{') {
                    open_bracket_count = 1
                }

                var in_str: Bool = false
                while (end_group_index < (a.size - 1)) {
                    if (a[end_group_index] == '\"' || a[end_group_index] == '\'') {
                        if (in_str) {
                            var backslash_index: Int64 = end_group_index - 1
                            while (backslash_index > -1 && a[backslash_index] == '\\') {
                                in_str = !in_str
                                backslash_index -= 1
                            }
                        }
                        in_str = !in_str
                    }
                    if (!in_str && a[end_group_index] == '{') {
                        open_bracket_count += 1
                    }
                    if (in_str || a[end_group_index] != '}') {
                        end_group_index += 1
                        continue
                    } else if (a[end_group_index] == '}' && open_bracket_count > 1) {
                        open_bracket_count -= 1
                        end_group_index += 1
                        continue
                    }

                    // Increase end_group_index by 1 to get the closing bracket
                    end_group_index += 1

                    new_a.append(a.slice(start_group_index, end_group_index - start_group_index))

                    /*
                     * The next start index is at least after the closing bracket,
                     * a closing bracket can be followed by a comma since we are in an array.
                     */
                    start_group_index = end_group_index + 1
                    while (start_group_index < (a.size - 1) && a[start_group_index] != '{') {
                        start_group_index += 1
                    }
                    end_group_index = start_group_index + 1
                }
                aArray = new_a
            }
            var b: Int64 = 0
            if (strArray) {
                while (b < aArray.size - 1) {
                    var ab: String = aArray[b].trim()
                    while (!boundedString(ab) ||
                           (ab.size > 2 &&
                            ab[0] == ab[1] && ab[1] == ab[2] &&
                            ab[ab.size - 2] != ab[0] &&
                            ab[ab.size - 3] != ab[0])) {
                        aArray.set(b, aArray[b] + "," + aArray[b + 1])
                        ab = aArray[b].trim()
                        if (b < aArray.size - 2) {
                            aArray = aArray[0..(b + 1)]
                            aArray.appendAll(aArray[(b + 2)..(aArray.size)])
                        } else {
                            aArray = aArray[0..(b + 1)]
                        }
                    }
                    b += 1
                }
            }
        } else {
            let al: Array<Char> = a.slice(1, a.size - 2).toCharArray()
            var openarr: Int64 = 0
            var j: Int64 = 0
            for (i in 0..al.size) {
                if (al[i] == '[') {
                    openarr += 1
                } else if (al[i] == ']') {
                    openarr -= 1
                } else if (al[i] == ',' && openarr != 0) {
                    aArray.append(String(al[j..i]))
                    j = i + 1
                }
            }
            aArray.append(String(al[j..al.size]))
        }
        for (i in 0..aArray.size) {
            aArray.set(i, aArray[i].trim())
            if (!aArray[i].equals("")) {
                let (nval, ntype): (ArrayList<String>, String) = loadValue(aArray[i])
                if (!atype.isEmpty()) {
                    if (!ntype.equals(atype)) {
                        throw Exception("ValueError: Not a homogeneous array")
                    }
                } else {
                    atype = ntype
                }
                retval.appendAll(nval)
            }
        }
        return retval
    }

    /*
     * The Function is loadInlineObject
     *
     * @param str of String
     * @param obj of JsonObject
     * @param multikey of Bool, and the Default value is false
     * @param multiBackSlash of Bool, and the Default value is false
     *
     * @since 0.29.3
     */
    private func loadInlineObject(str: String, obj: JsonObject, multiBackSlash!: Bool = false){
        var candidate_groups = ArrayList<String>(str[1..str.size-1].split(","))
        var groups = ArrayList<String>()
        if (candidate_groups.size == 1 && candidate_groups[0].trim().isEmpty()) {
            throw Exception("not Support3")
        }
        while (candidate_groups.size > 0){
            var candidate_group: String = candidate_groups[0]
            candidate_groups.remove(0)
            let val = candidate_group.split('=', 2)
            let value = val[1].trim()
            if (value[0] == value[value.size-1] && (value[0] == '\'' || value[0] == '"') || "-0123456789".contains(value[0]) || (value == "true" || value == "false") || (value[0] == '[' && value[value.size -1] == ']') || (value[0] == '{' && value[value.size -1] == '}') ) {
                groups.append(candidate_group)
            }
            else {
                throw Exception("not Support4")
            }
        }
        for (group in groups) {
            match(loadLine(obj, group, "", multiBackSlash)) {
                case Some(_) => break
                case None => ()
            }
        }
        
    }
    
    /*
     * The Function is load_unicode_escapes
     *
     * @param v of String
     * @param hexbytes of Array<String>
     * @param prefix of String
     *
     * @return Type of String
     * @since 0.29.3
     */
    private func load_unicode_escapes(v: String, hexbytes: Array<String>, prefix: String): String {
        return v
    }
    private let mypsbs = ['0', 'b', 'f', 'n', 'r', 't', '"']
    /*
     * The Function is getInchars
     *
     * @param c of Char
     *
     * @return Type of Bool
     * @since 0.29.3
     */
    private func getInchars(c: Char): Bool {
        for (m in mypsbs) {
            if (c == m) {
                return true
            }
        }
        return false
    }
    /*
     * The Function is unescape
     *
     * @param vs of String
     *
     * @return Type of String
     * @since 0.29.3
     */
    private func unescape(vs: String): String {
        var v = vs
        var i : Int64 = 0
        var backslash = false
        while (i < v.size) {
            if (backslash){
                backslash = false
                if (getInchars(v[i])) {
                    v = v[0..i-1] + v[i] + v[i+1..]
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
    
    /*
     * The Function is readData
     *
     *
     * @return Type of String
     * @since 0.29.3
     */
    private func readData(): String {
        let data: String = match(mode) {
            case STREAM => { =>
                let s: InputStream = match(stream) {
                    case Some(st: InputStream) => st
                    case _ => throw Exception("The stream must be initialize")
                }
                let res: StringBuilder = StringBuilder()
                var readLength: Int64 = 0
                var buffer: Array<Byte> = Array<Byte>(DEFAULT_BUFFER_SIZE, item: 0)
                do {
                    readLength = s.read(buffer)
                    if (0 != readLength) {
                        res.append(String.fromUtf8(buffer[0..readLength]))
                    }
                } while (readLength == DEFAULT_BUFFER_SIZE)
                res.toString()}()
            case _ => throw Exception("Must specify the data source first")
        }
        data
    }
    
    /*
     * The Function is getSplitOnQuotes
     *
     * @param line of String
     *
     * @return Type of Collection<String>
     * @since 0.29.3
     */
    private func getSplitOnQuotes(line: String): Collection<String> {
        var doubuleQuoteArr: Array<String> = line.split('"')
        var quoted: Bool = false
        let quotesplits = ArrayList<String>()
        if (doubuleQuoteArr.size > 1 && doubuleQuoteArr[0].contains("'")) {
            var singleQuotesArr: ArrayList<String> = ArrayList<String>(doubuleQuoteArr[0].split("'"))
            doubuleQuoteArr = doubuleQuoteArr.slice(1, doubuleQuoteArr.size-1)
            while (singleQuotesArr.size % 2 == 0 && doubuleQuoteArr.size > 0) {
                singleQuotesArr[singleQuotesArr.size - 1] = ##""${doubuleQuoteArr[0]}"## + singleQuotesArr[singleQuotesArr.size - 1]
                if (doubuleQuoteArr.size > 1) {
                    doubuleQuoteArr = doubuleQuoteArr.slice(1, doubuleQuoteArr.size-1)
                }else {
                    doubuleQuoteArr = Array<String>()
                }
            }
            quotesplits.appendAll(singleQuotesArr)
        }
        for ( item in doubuleQuoteArr) {
            if (quoted) {
                quotesplits.append(item)
            } else {
                quotesplits.appendAll(item.split("'"))
                quoted = !quoted
            }
        }
        return quotesplits
    }
    
    /*
     * The Function is strictlyValidNum
     *
     * @param str of String
     *
     * @return Type of Bool
     * @since 0.29.3
     */
    private func strictlyValidNum(str: String): Bool {
        let n = str.trim()
        let syb = ['.', 'o', 'b', 'x']
        return match {
            case n.isEmpty() => false
            case n[0] == '_' => false
            case n[n.size-1] == '_' => false
            case n.contains("_.") || n.contains("._") => false
            case n.size == 1 => true
            case n[0] == '0' && !syb.contains(n[1])  => false
            case n[0] == '+' || n[0] == '-' =>
                return if (n.size > 2 && n[1] == '0' && n[2] != '.') {
                false
            } else {
                true
            }
            case n.contains("__") => false
            case _ => true
        }
    }
    
    /*
     * The Function is loadLine
     *
     * @param jvconst of JsonObject
     * @param line of String
     * @param mls of String
     * @param mbs of Bool)
     * @param Bool) of Option<(String,String,Bool)>
     *
     * @since 0.29.3
     */
    func loadLine(jvconst: JsonObject, line: String, mls: String, mbs: Bool): Option<(String,String,Bool)> {

        var multiBackSlash = mbs
        var multikey = mls
        var jv = jvconst
        var i = 1
        var quoteSplits = getSplitOnQuotes(line)
        var quoted = false
        var vtype: String = ""
        for (quoteSplit in quoteSplits) {
            if (!quoted && quoteSplit.contains('=')){
                break;
            }
            i += quoteSplit.count('=')
            quoted = !quoted
        }
        var pair = line.split('=', i+1)

        strictlyValidNum(pair[pair.size - 1])
        match (numberWithUnderScores.matcher(pair[pair.size - 1]).fullMatch()) {
            case Some(_) => pair[pair.size - 1] = pair[pair.size - 1].replace("_", "")
            case None => ()
        }

        pair[pair.size - 1]

        let strPair0: String = String.join(pair[0..(pair.size - 1)], delimiter: "=")
        pair = [strPair0.trim(), pair[pair.size - 1].trim()]

        if (pair[0].contains('.')) {
            var levels: ArrayList<String>
            if (pair[0].contains('"') || pair[0].contains('\'')) {
                quoteSplits = getSplitOnQuotes(pair[0])
                quoted = false
                levels = ArrayList<String>()
                for (quoteSplit in quoteSplits) {
                    if (quoted) {
                        levels.append(quoteSplit)
                    } else {
                        for (arri in quoteSplit.split('.')) {
                            levels.append(arri.trim())
                        }
                    }
                    quoted = !quoted
                }
            } else {
                levels = ArrayList<String>(pair[0].split('.'))
            }
            while (levels[levels.size-1] == "") {
                levels.remove(levels.size-1)
            }
            for (levelIndx in 0..levels.size - 2) {
                
                if (!jv.containsKey(levels[levelIndx])) {
                    jv.put(levels[levelIndx], JsonObject())
                }
                jv = jv.get(levels[levelIndx]).getOrThrow().asObject()
            }
            pair[0] = levels[levels.size-1].trim()
        } else if ((pair[0][0] == '\"' || pair[0][0] == '\'') && (pair[0][pair.size - 1] == pair[0][0])) {
            pair[0] = unescape(pair[0].slice(1, pair[0].size - 2))
        }

        let (k_tuple, koffset_tuple) = loadLineMultilineStr(pair[1])

        var k = k_tuple
        var koffset = koffset_tuple
        var value: ArrayList<String> = ArrayList<String>()
        var multiLineStr = ""
        if (k > -1) {
            while(k > -1 && pair[1][k + koffset] == '\\') {
                multiBackSlash = !multiBackSlash
                k -= 1
            }
            if (multiBackSlash) {
                multiLineStr = pair[1][..pair[1].size-1]
            }
            multikey = pair[0]
        } else {
            let res: (ArrayList<String>, String) = loadValue(pair[1])
            value = res[0]
            vtype = res[1]
        }

        try {
            jv = jv.get(pair[0]).getOrThrow().asObject()
        } catch (e: Exception) {
            if (!multikey.isEmpty()) {
                return Some((multikey, multiLineStr, multiBackSlash))
            } else {
                if (vtype.equals("array")) {
                    let ja: JsonArray = JsonArray()
                    for (str in value) {
                        ja.add(JsonString(str))
                    }
                    jvconst.put(pair[0], ja)
                } else {
                    jvconst.put(pair[0], JsonString(value[0].replace("\\", "")))
                }

            }
        }
        return None

    }
}
