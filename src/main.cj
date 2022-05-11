/*
 * Copyright (c) Cangjie Community 2022-2022. All rights reserved.
 * Note: This software have been NOT specify lincense.
 * Description:
 */

import decoders.*

main() {
    let decoder: Decoder = Decoder()
    decoder.load("res/example.toml")
    decoder.decode()
}