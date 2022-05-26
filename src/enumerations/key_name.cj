/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about key name
 */

package enumerations

public enum KeyName {
    | Str(String)
    | List(KeyName)
}