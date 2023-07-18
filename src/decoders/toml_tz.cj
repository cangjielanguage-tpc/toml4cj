/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about Symbols
 */

package decoders


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
        return (Duration.hour(hour) + Duration.minute(minute) * sign)
    }

    /**
     * The Function is dst
     *
     *
     * @since 0.29.3
     */
    public func dst() {
        return Duration.hour(0) + Duration.minute(0) + Duration.second(0) + Duration.microsecond(0) + Duration.nanosecond(0)
    }

    /**
     * The Function is location
     *
     *
     * @return Type of Location
     * @since 0.29.3
     */
    public func location(): Location {
        Location(tzname(), utcOffset())
    }
}