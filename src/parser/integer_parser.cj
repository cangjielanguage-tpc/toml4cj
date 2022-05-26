/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about Integer parse.
 */

package parser

from std import regex.*
from std import convert.*

/**
 * The class is IntegerParser inherited from Parsable
 * @author Annlix
 * @since 0.28.4
 */
public class IntegerParser <: Parsable {
    
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
        
        match(parseInt64(rightValue)) {
            case Some(x) => Ok(Value.Integer(x))
            case None => Err(Exception("Not a integer"))
        }
    }

}