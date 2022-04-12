/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package decoders.parsers

from std import regex.*
from std import convert.*

public class IntegerParser <: Parsable {
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