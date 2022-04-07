package decoders

public class Symbols {
    static public let QUOTE: String = String.fromUtf8([0x22])
    static public let LF: String = String.fromUtf8([0x0A])
    static public let CRLF: String = String.fromUtf8([0x0D, 0x0A])
    static public let TRIPLE_QUOTE: String = String.fromUtf8([0x22, 0x22, 0x22])
    static public let SINGLE_QUOTE: String = String.fromUtf8([0x27])
    static public let TRIPLE_SINGLE_QUOTE: String = String.fromUtf8([0x27, 0x27, 0x27])
    static public let EQUAL_SYMBOL: String = String.fromUtf8([0x3D])
}