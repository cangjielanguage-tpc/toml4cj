

@Test
class TestUtils {
    @TestCase
    func testIsInteger(): Unit {
        let s1: String = "123456"
        let s2: String = "-123456"
        let s3: String = "123.456"
        let s4: String = "-123.456"
        let s5: String = "123abc"
        let s6: String = "abc123"
        let s7: String = "abcdef"

        @Expect(Utils.isInteger(s1), true)
        @Expect(Utils.isInteger(s2), true)
        @Expect(Utils.isInteger(s3), false)
        @Expect(Utils.isInteger(s4), false)
        @Expect(Utils.isInteger(s5), false)
        @Expect(Utils.isInteger(s6), false)
        @Expect(Utils.isInteger(s7), false)
    }

    @TestCase
    func testGetQuoteValue(): Unit {
        let s1: String = String.fromUtf8([0x22, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x22]) // "foobar"
        let s2: String = String.fromUtf8([0x27, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x27]) // 'foobar'
        let s3: String = String.fromUtf8([0x22, 0x22, 0x22, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x22, 0x22, 0x22]) // """foobar"""
        let s4: String = String.fromUtf8([0x27, 0x27, 0x27, 0x66, 0x6f, 0x6f, 0x62, 0x61, 0x72, 0x27, 0x27, 0x27]) // '''foobar'''

        @Expect(Utils.getQuoteValue(s1), "foobar")
        @Expect(Utils.getQuoteValue(s2), "foobar")
        @Expect(Utils.getQuoteValue(s3), "foobar")
        @Expect(Utils.getQuoteValue(s4), "foobar")
    }
}