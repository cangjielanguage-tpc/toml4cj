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
public interface Parsable {
    func asA(line: String): Result<Value>
}