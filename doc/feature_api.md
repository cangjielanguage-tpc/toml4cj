## toml 库

### 介绍
TOML 旨在成为一个语义明显且易于阅读的最小化配置文件格式。TOML 被设计成可以无歧义地映射为哈希表。TOML 应该能很容易地被解析成各种语言中的数据结构。

参考toml语法规约地址: https://toml.io/cn/。

### 1 提供读取TOML数据的功能

前置条件：NA 

场景：
1. 读取toml文件，支持TOML v1.0.0

约束：NA

性能：NA

可靠性： NA

#### 1.1 toml 读取

##### 1.1.1 主要接口

###### class Decoder

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

##### 1.1.2 示例

代码如下：

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

运行结果如下：

```cangjie
{"key":"value","bare_key":"value","bare-key":"value","1234":"value"}
```

### 2 提供解析TOML数据的功能

前置条件：NA 

场景：
1. 读取toml文件，支持TOML v1.0.0

约束：

性能： NA

可靠性： 目前只实现对整数、浮点数、字符串、布尔类型字面量的解码。

#### 2.1 toml 解析

##### 2.1.1 主要接口

###### class Decoder

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

##### 2.1.2 示例

代码如下：

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

运行结果如下：

```cangjie
{"key":"value","bare_key":"value","bare-key":"value","1234":"value"}
```

### 3 提供序列化TOML数据的功能

前置条件：NA 

场景：
1. 读取toml文件，解析toml文件方便仓颉读取，支持TOML v1.0.0

约束：目前只实现对整数、浮点数、字符串、布尔类型字面量的解码。

性能： NA

可靠性： NA

#### 3.1 序列化成toml格式数据

##### 3.1.1 主要接口

###### class TomlTz

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

##### 3.1.2 示例

代码如下：

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

运行结果如下：

```cangjie
{"key":"value","bare_key":"value","bare-key":"value","1234":"value"}
```
