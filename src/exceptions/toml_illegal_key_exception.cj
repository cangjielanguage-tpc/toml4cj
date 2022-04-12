/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package exceptions

public class TomlIllegalKeyException <: TomlBaseException {
    public init() {
        this("Illegal toml key")
    }

    public init(message: String) {
        super(message)
    }
}