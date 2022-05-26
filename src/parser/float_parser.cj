/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about Float parse.
 */
package parser

/**
 * The class is FloarParser inherited from Parsable
 * @author Annlix
 * @since 0.28.4
 */
public class FloarParser <: Parsable {
    
    /**
     * The Function is asA
     *
     * @param line of String
     *
     * @return Type of Result<Value>
     * @since 0.28.4
     */
    public func asA(line: String): Result<Value> {
        var rightValue: String = line.split("=", 2, removeEmpty: true)[1]
        let numberSignIndex = rightValue.indexOf("#") ?? -1
        if (numberSignIndex == 0) {
            throw Exception("Invalid value defination")
        }
        if (numberSignIndex > 0) {
            rightValue = rightValue.substring(0, numberSignIndex)
        }
        
        match(parseFloat64(rightValue)) {
            case Some(x) => Ok(Value.Float(x))
            case None => Err(Exception("Not a float"))
        }
    }
}