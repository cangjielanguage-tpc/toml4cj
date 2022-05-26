/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about parse element
 */
package decoders

from std import unicode.* 

/**
 * The class is Element
 * @author @Annlix
 * @since 0.28.4
 */
public class Element {
    let lines: Array<String>

    /*
     * The Function is init constructor
     *
     * @param lines of Array<String>
     *
     * @since 0.28.4
     */
    init(lines: Array<String>) {
        this.lines = lines
    }

    /**
     * The Function is parse
     *
     * @param sep of String
     *
     * @return Type of HashMap<String, Array<Byte>>
     * @since 0.28.4
     */
    public func parse(sep: String): HashMap<String, Array<Byte>> {
        let docMap: HashMap<String, Array<Byte>> = HashMap<String, Array<Byte>>() 
        let lineCount: Int64 = lines.size()
        var lineNo: Int64 = 0
        while (lineNo < lineCount) {
            var key: String = ""
            var value: String = ""
            var line: String = lines[lineNo]
            let equalSignIndex: Int64 = line.indexOf(Symbols.EQUAL_SYMBOL) ?? -1
            // Judge whether it is a comment
            if (line.trim().charAt(0) == Symbols.NUMBER_SIGN.charAt(0)) {
                lineNo+=1
                continue
            }
            if (line.isBlank()) {
                lineNo += 1
                continue
            }

            if (0 == equalSignIndex) {
                throw Exception("Invalid toml format")
            }
            
            var leftValue: String = ""
            var rightValue: String = ""
            if (equalSignIndex > 0) {
                leftValue = line.substring(0, equalSignIndex)
                rightValue = line.substring(equalSignIndex + 1)
            } else {
                // Table or table array
            }
            // Multiline text
            if (0 < (line.indexOf(Symbols.TRIPLE_QUOTE) ?? 0)) {
                // Todo: need to optimize
                // If the first non blank space on the left of multiline text is an equal sign, it is multiline text
                let tripleQuoteIndex: Int64 = line.indexOf(Symbols.TRIPLE_QUOTE) ?? 0
                // Gets the first equal sign of the current row
                let equalSignIndex: Int64 = line.indexOf(Symbols.EQUAL_SYMBOL) ?? 0
                key = line.substring(0, equalSignIndex - 1).trim()
                // Finds whether there is a multiline text end tag at the end of the current line
                let lastTripleQuoteIndex = line.lastIndexOf(Symbols.TRIPLE_QUOTE) ?? -1
                let valueStartAt: Int64 = tripleQuoteIndex + Symbols.TRIPLE_QUOTE.size()
                if (lastTripleQuoteIndex > tripleQuoteIndex) {
                    // Ends multiple lines of text in the current line
                    value = line.substring(valueStartAt, lastTripleQuoteIndex - valueStartAt)
                } else {
                    // No multiline text found on current line
                    value += (line.substring(valueStartAt) + appendNewline(line, sep))
                    // Keep looking
                    while (true) {
                        lineNo += 1
                        line = lines[lineNo]
                        let tripleQuoteIndex = line.indexOf(Symbols.TRIPLE_QUOTE) ?? -1
                        if (tripleQuoteIndex == -1) {
                            value += (line + appendNewline(line, sep))
                        } else {
                            value += line.substring(0, tripleQuoteIndex)
                            break
                        }
                    }
                }
                // let subStr: String = line.substring(equalSignIndex + 1, (tripleQuoteIndex - equalSignIndex - 1))
                // if (subStr.isBlank()) {
                //     // Multiline text
                //     // Looking for the next """ position
                //     let removeBlank: Bool = true
                //     var start: Int64 = tripleQuoteIndex + 3

                //     while (true) {
                //         let lastTripleQuoteIndex = line.lastIndexOf(Symbols.TRIPLE_QUOTE) ?? -1
                //         if (lastTripleQuoteIndex > tripleQuoteIndex || lastTripleQuoteIndex == 0) {
                //             // An end symbol was found on the current line
                //             let length = if (start == 0) {0} else {lastTripleQuoteIndex - start - 1}
                //             start = if (start == 0) {0} else {start + 1}
                //             value += line.substring(start + 1, length)
                //             break
                //         } else {
                //             // No end symbol found on current line
                //             value += line.substring(start)
                //             start = 0
                //             lineNo += 1
                //             line = lines[lineNo]
                //         }
                //     }
                // }
                docMap.put(key, value.toUtf8Array())
                lineNo += 1
            }
            lineNo += 1
            // Todo: integer
            // if (!rightValue.isEmpty() && rightValue.trim())
            // Todo: float
            // Todo: Boolean
            // Todo: Date time
            // Todo: Single line text
            // Todo: array
            // Todo: list
        }
        docMap
    }

    /*
     * The Function is appendNewline
     *
     * @param line of String
     * @param sep of String
     *
     * @return Type of String
     * @since 0.28.4
     */
    private func appendNewline(line: String, sep: String): String {
        if (line.trimAsciiRight().endsWith("\\")) {
            ""
        }
        sep
    }
}