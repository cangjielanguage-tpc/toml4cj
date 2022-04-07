/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package decoders.parsers

import enumerations.Value

/**
 * parser 抽象类
 *
 * @description: SubParser需要继承该抽象类
 */
interface Parserable {
    func isA(value: String): Bool
    func asA(value: Array<Byte>, key!: String): Result<Value>
}