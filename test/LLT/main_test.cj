// DEPENDENCE integer002.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml import decoders.*

main() {
    let decoder: Decoder = Decoder()
    decoder.load("integer002.toml")
    decoder.decode()

}