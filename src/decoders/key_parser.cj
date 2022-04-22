package decoders

import exceptions.TomlIllegalKeyException

public class KeyParser {
    public func parse(payload: String): Key {
        var line = payload.trim()
        var key: Key = Key()
        if (line.startsWith(Symbols.EQUAL_SYMBOL)) {
            throw TomlIllegalKeyException()
        }
        if (line.startsWith(Symbols.LEFT_SQUARE_BRACKET)) {
            // Table or table array
        } else {
            var values: Array<String>
            var leftValue: String
            var rightValue: String
            values = line.split(Symbols.EQUAL_SYMBOL, 2, removeEmpty: false)
            leftValue = values[0]
            rightValue = values[1]
            
        }
        key
    }
}