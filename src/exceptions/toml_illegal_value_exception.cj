/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package exceptions

public class TomlIllegalValueException <: TomlBaseException {
    public init() {
        this("Illegal toml value")
    }

    public init(message: String) {
        super(message)
    }
}