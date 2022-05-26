/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file is about interface Parsable
 */
 
package parser

import enumerations.Value

/**
 * The interface is ic interface Parsable
 * @author Annlix
 * @since 0.28.4
 */
public interface Parsable {
    func asA(line: String): Result<Value>
}