/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

package enumerations

from std import time.Time
from std import collection.HashMap

public enum Value {
    | Str(String)
    | Integer(Int64)
    | Float(Float64)
    | Boolean(Bool)
    | DateTime(Time)
    | List(Array<Any>) // 由于在 Cangjie 0.27.2 （不含）以后的版本计划移除 list 类型，因此此处采用 list 代替数组
    | Map(HashMap<String, Hashable>)
}