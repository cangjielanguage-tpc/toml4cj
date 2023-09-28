// DEPENDENCE: 1.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from toml4cj import decoders.*
from encoding import json.*

main() {
	var url: String = "1.toml"
    let decoder: Decoder = Decoder()

    decoder.load(url)

    try {
        let json: JsonObject = decoder.decode()

        println("-------------------------------------------------------")
        println(json.toJsonString())
        println("-------------------------------------------------------")
    }catch (e: Exception) {
        e.printStackTrace()
        return 1
    }

    return 0
}
