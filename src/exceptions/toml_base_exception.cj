/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package exceptions

public open class TomlBaseException <: Exception {
    public init() {
        this("Some error occurred")
    }

    public init(message: String) {
        super(message)
    }
}