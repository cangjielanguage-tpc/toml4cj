/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about comment function
 */
from std import regex.*
from std import collection.*
from std import math.*

/**
 * The class is Utils
 * @author @Annlix
 * @since 0.28.4
 */
public class Utils {
    /**
     * The Function is isInteger
     *
     * @param s of String
     *
     * @return Type of Bool
     * @since 0.28.4
     */
    public static func isInteger(s: String): Bool {
        let reg = Regex("^(\\-|\\+)?\\d+$")
        let matcher = Matcher(reg, s)
        match (matcher.fullMatch()) {
            case Some(r) => true
            case None => false
        }
    }

    /**
     * @summary: Extract double quotes(")、Single quotation mark(')、Triple double quotation mark(""")、Triple single quotation mark(''')String contained in the middle
     * @description: as:
     *     let s1: String = String.fromUtf8([0x22, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x22]) // "foobar"
     *     getQuoteValue(s1) // foobar
     *     let s2: String = String.fromUtf8([0x27, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x27]) // 'foobar'
     *     getQuoteValue(s2) // foobar
     *     let s3: String = String.fromUtf8([0x22, 0x22, 0x22, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x22, 0x22, 0x22]) // """foobar"""
     *     getQuoteValue(s3) // foobar
     *     let s4: String = String.fromUtf8([0x27, 0x27, 0x27, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x27, 0x27, 0x27]) // '''foobar'''
     *     getQuoteValue(s4) // foobar
     *
     * @todo: When the string contains escape quotation marks, the function cannot get the result normally
     * @author: Annlix<Annlix@outlook.com>
     * @params: payload: String - Original string
     *
     * @return: String - The string contained between the symbols listed above.
     * @since 0.28.4
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