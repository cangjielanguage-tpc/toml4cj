# toml 库

主要接口

class Decoder

定义 toml Decoder 类
```cangjie
public class Decoder {

    /*
     * 初始化 Decoder
     */
    public init()

    /*
     * 加载toml文件路径字符串
     *
     * 参数 pn - toml文件路径字符串, 只限于linux环境
     */
    public func load(pn: String)

    /*
     * 加载toml文件路径字符串
     *
     * 参数 file - toml文件路径File对象
     */
    public func load(file: File)

    /*
     * 解析toml文件返回生成json格式的对象
     *
     * 返回值 JsonObject - json对象
     */
    public func decode(): JsonObject
}


```

定义 toml TomlTz 类
```cangjie
public class TomlTz {
    /*
     * 初始化 TomlTz
     * 参数 tomlOffset - 偏移量
     */
    public init(tomlOffset: String)

    /*
     * 返回tzname 名称
     *
     * 返回值 String - 返回时区和偏移量的字符串
     */
    public func tzname(): String

    /*
     * 返回UTC时区+偏移量的Duration
     *
     * 返回值 Duration - 返回时区和偏移量的Duration
     */
    public func utcOffset(): Duration

    /*
     * 返回时间间隔Duration
     *
     * 返回值 Duration - 返回时间间隔Duration
     */
    public func dst() : Duration

    /*
     * 返回系统本地时间Duration
     *
     * 返回值 Duration - 返回系统本地时间Duration
     */
    public func location(): Location
}
```

### 示例 
integer002.toml文件
```toml
key = "value"
bare_key = "value"
bare-key = "value"
1234 = "value"
```
```cangjie
from toml import decoders.*

main() {
    let decoder: Decoder = Decoder()
    decoder.load("integer002.toml")
    let a = decoder.decode()
    println(a)
}
```
**运行结果：**
```cangjie
{"key":"value","bare_key":"value","bare-key":"value","1234":"value"}
```