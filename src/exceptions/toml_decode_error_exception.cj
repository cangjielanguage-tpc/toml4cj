/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about toml decode error exception
 */
package exceptions

/**
 * The class is TomlDecodeErrorException inherited from TomlBaseException
 * @author @Annlix
 * @since 0.28.4
 */
public class TomlDecodeErrorException <: TomlBaseException {
    /**
     * The Function is init constructor
     *
     * @since 0.28.4
     */
    public init() {
        this("Some error occurred when decode the toml data")
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