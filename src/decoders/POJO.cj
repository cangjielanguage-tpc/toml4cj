/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about key
 */
package decoders

from std import unicode.*

from std import time.Time
from std import collection.HashMap

public enum DecodeMode {
    | UNSPECIFIED
    | STREAM
    | STRING
}