/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about key parse
 */
package decoders

import exceptions.TomlIllegalKeyException

/**
 * The class is KeyParser
 * @author Annlix
 * @since 0.28.4
 */
public class KeyParser {
    
    /**
     * The Function is parse
     *
     * @param payload of String
     *
     * @return Type of Key
     * @since 0.28.4
     */
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