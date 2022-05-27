/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about interface Parsable
 */

package decoders

/**
 * The interface is ic interface Parsable
 * @author Annlix
 * @since 0.28.4
 */
public interface Parsable {
    func asA(line: String): Result<Value>
}

/**
 * The class is BooleanParser inherited from Parsable
 * @author Annlix
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


