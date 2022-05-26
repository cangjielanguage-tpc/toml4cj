from std import regex.*
from std import collection.*
from std import math.*

public class Utils {
    public static func isInteger(s: String): Bool {
        let reg = Regex("^(\\-|\\+)?\\d+$")
        let matcher = Matcher(reg, s)
        match (matcher.fullMatch()) {
            case Some(r) => true
            case None => false
        }
    }

    /**
     * @summary: 提取双引号（"）、单引号（'）、三重双引号（"""）、三重单引号（'''）中间包含的字符串
     * @description: 如：
     *     let s1: String = String.fromUtf8([0x22, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x22]) // "foobar"
     *     getQuoteValue(s1) // foobar
     *     let s2: String = String.fromUtf8([0x27, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x27]) // 'foobar'
     *     getQuoteValue(s2) // foobar
     *     let s3: String = String.fromUtf8([0x22, 0x22, 0x22, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x22, 0x22, 0x22]) // """foobar"""
     *     getQuoteValue(s3) // foobar
     *     let s4: String = String.fromUtf8([0x27, 0x27, 0x27, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x27, 0x27, 0x27]) // '''foobar'''
     *     getQuoteValue(s4) // foobar
     *
     * @todo: 字符串中含有转义引号的时候，该函数无法正常获取结果
     * @author: Annlix<Annlix@outlook.com>
     * @params: payload: String - 原始字符串
     * @return: String - 上述列出的符号中间包含的字符串。
     */
    public static func getQuoteValue(payload: String): String {
        let line: String = payload.trimAscii()
        let prefix: String
        let firstChar: Char = line.charAt(0)
        let innerValue: StringBuilder = StringBuilder()
        if (firstChar == line.charAt(1) && firstChar == line.charAt(2)) {
            prefix = line.substring(0, 3)
        } else {
            prefix = line.substring(0, 1)
        }
        let loopCount: Int64 = Int64(ceil((Float64(line.size()) / Float64(prefix.size()))))
        for (i in 1..=loopCount) {
            let subStr: String = line.substring(i * prefix.size(), prefix.size())
            if (subStr.equals(prefix)) {
                break
            }
            innerValue.append(subStr)
        }
        innerValue.toString()
    }
}