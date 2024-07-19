// DEPENDENCE: 2.toml
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import toml4cj.decoders.*
import encoding.json.*

main() {
	var url: String = "2.toml"
    let decoder: Decoder = Decoder()

    decoder.load(url)

    try {
        let json: JsonObject = decoder.decode()

        println("-------------------------------------------------------")
        println(json.toJsonString())
        println("-------------------------------------------------------")
    }catch (e: Exception) {
        e.printStackTrace()
        return 0
    }

    return 1
}
