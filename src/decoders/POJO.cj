/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about key
 */
package decoders

from std import unicode.*

from std import time.Time
from std import collection.HashMap
public enum Value {
    | Str(String)
    | Integer(Int64)
    | Float(Float64)
    | Boolean(Bool)
    | DateTime(Time)
    | Array(Array<Any>) // 由于在 Cangjie 0.27.2 （不含）以后的版本计划移除 list 类型，因此此处采用 list 代替数组
    | Map(HashMap<String, Hashable>)
}


public enum DecodeMode {
    | UNSPECIFIED
    | STREAM
    | STRING
}


public enum KeyName {
    | Str(String)
    | List(KeyName)
}


public enum KeyType {
    | Str
    | Obj
    | Arr
}

/**
 * The class is Key inherited from ToString & Hashable & Equatable<Key>
 * @author Annlix
 * @since 0.28.4
 */
public class Key <: ToString & Hashable & Equatable<Key> {
    /* The name of the current key */
    var name: String = ""
    /* Contents of the next key */
    var next: ArrayList<Key> = ArrayList<Key>([])

    /**
     * The Function is init constructor
     *
     * @param name of String
     * @param next of Key
     *
     * @since 0.28.4
     */
    public init(name: String, next: Key) {
        this.name = name
        this.next.add(next)
    }

    /**
     * The Function is init constructor
     *
     * @since 0.28.4
     */
    public init() {

    }

    /**
     * The Function is toString
     *
     * @return Type of String
     * @since 0.28.4
     */
    public func toString(): String {
        var str: String = ""
        let len: UInt64 = UInt64(next.size())
        println(len)
        // if (len == 0) {
        //     str = name
        // } else if (len == 1) {
        //     str = name + "." + next.toString()
        // } else if (len > 1) {
        //     let nextsStr: ArrayList<String> = ArrayList<String>(len)
        //     for (item in next) {
        //         nextsStr.add(name + "." + item.toString())
        //     }
        //     str = String.join(Array<String>(nextsStr), Symbols.DOT)
        // }
        str
    }

    /**
     * The Function is hashCode
     *
     * @return Type of Int64
     * @since 0.28.4
     */
    public func hashCode(): Int64 {
        toString().hashCode()
    }

    /**
     * The Function is ==
     *
     * @param rhs of Key
     *
     * @return Type of Bool
     * @since 0.28.4
     */
    public operator func ==(rhs: Key): Bool {
        toString().equals(rhs.toString())
    }

    /**
     * The Function is !=
     *
     * @param rhs of Key
     *
     * @return Type of Bool
     * @since 0.28.4
     */
    public operator func !=(rhs: Key): Bool {
        !toString().equals(rhs.toString())
    }

    /**
     * The Function is add
     *
     * @param nameItem of String
     *
     * @since 0.28.4
     */
    // public mut func add(nameItem: String) {
    //     name.add(nameItem)
    // }

    /**
     * The Function is setName
     *
     * @param n of String
     *
     * @return Type of Unit
     * @since 0.28.4
     */
    public func setName(n: String): Unit {
        name = n
    }
}