/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file is about toml exception
 */

package exceptions

/**
 * The class is TomlBaseException inherited from Exception
 * @author @Annlix
 * @since 0.28.4
 */
public open class TomlBaseException <: Exception {
    
    /**
     * The Function is init constructor
     *
     * @since 0.28.4
     */
    public init() {
        this("Some error occurred")
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