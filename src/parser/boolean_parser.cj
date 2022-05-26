/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file is about Boolean parse.
 */
package parser

/**
 * The class is BooleanParser inherited from Parsable
 * @author @Annlix
 * @since 0.28.4
 */
public class BooleanParser <: Parsable {

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
        
        if (rightValue.equals("true")) {
            Ok(Value.Boolean(false))
        } else if(rightValue.equals("false")) {
            Ok(Value.Boolean(false))
        } else {
            Err(Exception("Maybe a string"))
        }
    }
}