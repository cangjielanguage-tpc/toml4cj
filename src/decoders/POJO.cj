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

/**
 * The enum is DecodeMode
 * @author Annlix
 * @since 0.28.4
 */
public enum DecodeMode {
    | UNSPECIFIED
    | STREAM
    | STRING
}