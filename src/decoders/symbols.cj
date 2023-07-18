/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about Symbols
 */

package decoders

/**
 * The class is Symbols
 * @author annlix
 * @since 0.29.3
 */
public class Symbols {
    static public let QUOTE: String = String.fromUtf8([0x22]) // "
    static public let CR: String = String.fromUtf8([0x0D]) // \r
    static public let LF: String = String.fromUtf8([0x0A]) // \n
    static public let CRLF: String = String.fromUtf8([0x0D, 0x0A]) // \r\n
    static public let TRIPLE_QUOTE: String = String.fromUtf8([0x22]) * 3  // """
    static public let SINGLE_QUOTE: String = String.fromUtf8([0x27]) // '
    static public let TRIPLE_SINGLE_QUOTE: String = String.fromUtf8([0x27]) * 3 // '''
    static public let EQUAL_SYMBOL: String = String.fromUtf8([0x3D]) // =
    static public let NUMBER_SIGN: String = String.fromUtf8([0x23]) // #
    static public let LEFT_SQUARE_BRACKET: String = String.fromUtf8([0x5B]) // [
    static public let RIGHT_SQUARE_BRACKET: String = String.fromUtf8([0x5D]) // ]
    static public let DOT: String = String.fromUtf8([0x2E]) // .
    static public let UNDERLINE: String = String.fromUtf8([0x5F]) // _
    static public let DASHED: String = String.fromUtf8([0x2D]) // -
    static public let FORWARD_SLASH: String = String.fromUtf8([0x2F]) // /
    static public let BACK_SLASH: String = String.fromUtf8([0x5C]) // \
    static public let SPACE: String = String.fromUtf8([0x20]) // SPACE
    static public let HORIZONTAL_TAB: String = String.fromUtf8([0x09]) // \t
    static public let LEFT_BRACE: String = String.fromUtf8([0x7B]) // {
    static public let RIGHT_BRACE: String = String.fromUtf8([0x7D]) // }
    static public let PLUS: String = String.fromUtf8([0x2B]) // +
}
