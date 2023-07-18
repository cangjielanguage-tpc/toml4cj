/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file is about toml4cj exception
 */

package decoders

/**
 * The class is TomlBaseException inherited from Exception
 * @author Annlix
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

/**
 * The class is TomlDecodeErrorException inherited from TomlBaseException
 * @author Annlix
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

/**
 * The class is TomlIllegalKeyException inherited from TomlBaseException
 * @author Annlix
 * @since 0.28.4
 */
public class TomlIllegalKeyException <: TomlBaseException {
    /**
     * The Function is init constructor
     *
     * @since 0.28.4
     */
    public init() {
        this("Illegal toml key")
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