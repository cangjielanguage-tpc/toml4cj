/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about toml illegal value error exception
 */

package exceptions

/**
 * The class is TomlIllegalValueException inherited from TomlBaseException
 * @author Annlix
 * @since 0.28.4
 */
public class TomlIllegalValueException <: TomlBaseException {
    /**
     * The Function is init constructor
     *
     * @since 0.28.4
     */
    public init() {
        this("Illegal toml value")
    }

    /**
     * The Function is init constructor
     *
     * @param message of String
     *
     * @since 0.28.4
     */
    public init(message: String) {
        super(message)
    }
}