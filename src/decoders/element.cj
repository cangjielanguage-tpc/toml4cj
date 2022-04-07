package decoders

from std import unicode.* 

public class Element {
    let lines: Array<String>

    init(lines: Array<String>) {
        this.lines = lines
    }

    public func parse(): HashMap<String, Array<Byte>> {
        let docMap: HashMap<String, Array<Byte>> = HashMap<String, Array<Byte>>() 
        let lineCount: Int64 = lines.size()
        var lineNo: Int64 = 0
        while (lineNo < lineCount) {
            var key: String = ""
            var value: String = ""
            var line: String = lines[lineNo]
            // 处理多行文本
            if (0 < (line.indexOf(Symbols.TRIPLE_QUOTE) ?? 0)) {
                // 如果多行文本的左边第一个非空白是等号则是多行文本
                let tripleQuoteIndex: Int64 = line.indexOf(Symbols.TRIPLE_QUOTE) ?? 0
                // 获取当前行的第一个等号
                let equalSignIndex: Int64 = line.indexOf(Symbols.EQUAL_SYMBOL) ?? 0
                key = line.substring(0, equalSignIndex - 1).trim()
                let subStr: String = line.substring(equalSignIndex - 1, (tripleQuoteIndex - equalSignIndex - 1))
                if (subStr.isBlank()) {
                    // 多行文本
                    // 寻找下一个"""的位置
                    let removeBlank: Bool = true
                    var start: Int64 = tripleQuoteIndex + 3

                    while (true) {
                        let lastTripleQuoteIndex = line.lastIndexOf(Symbols.TRIPLE_QUOTE) ?? -1
                        if (lastTripleQuoteIndex > tripleQuoteIndex || lastTripleQuoteIndex == 0) {
                            // 在当前行找到了结束符号
                            let length = if (start == 0) {0} else {lastTripleQuoteIndex - start - 1}
                            start = if (start == 0) {0} else {start + 1}
                            value += line.substring(start + 1, length)
                            break
                        } else {
                            // 在当前行没有找到结束符号
                            value += line.substring(start)
                            start = 0
                            lineNo += 1
                            line = lines[lineNo]
                        }
                    }
                }
                docMap.put(key, value.toUtf8Array())
            }
            lineNo += 1
        }
        docMap
    }
}