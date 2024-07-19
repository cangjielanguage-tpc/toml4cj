/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2022-2024. All rights reserved.
 */

/**
 * @file
 * This file is about Symbols
 */

package toml4cj.decoders

import std.fs.*
import std.io.InputStream
import std.collection.*
import std.regex.*
import std.unicode.*
import serialization.serialization.*
import std.convert.*
import std.time.*
import encoding.json.*


/**
 * The class is TomlTz
 * @author Annlix
 * @since 0.28.4
 */
public class TomlTz {
    private let rawOffset: String
    private let sign: Int64
    private let hour: Int64
    private let minute: Int64

    /*
     * The Function is init constructor
     *
     * @param tomlOffset of String
     *
     * @since 0.29.3
     */
    public init(tomlOffset: String) {
        if (tomlOffset == "Z") {
            rawOffset = "+00:00"
        } else {
            rawOffset = tomlOffset
        }
        if (rawOffset[0] == Symbols.DASHED[0]) {
            sign = 1
        } else {
            sign = -1
        }
        hour = Int64.tryParse(rawOffset[0..3]) ?? 0
        minute = Int64.tryParse(rawOffset[4..6]) ?? 0
    }

    /**
     * The Function is tzname
     *
     *
     * @since 0.29.3
     */
    public func tzname() {
        return "UTC" + rawOffset
    }

    /**
     * The Function is utcOffset
     *
     *
     * @since 0.29.3
     */
    public func utcOffset() {
        return (Duration.hour*hour + Duration.minute*minute * sign)
    }

    /**
     * The Function is dst
     *
     *
     * @since 0.29.3
     */
    public func dst() {
        return Duration.Zero
    }

    /**
     * The Function is TimeZone
     *
     *
     * @return Type of TimeZone
     * @since 0.29.3
     */
    public func location(): TimeZone {
        TimeZone(tzname(), utcOffset())
    }
}