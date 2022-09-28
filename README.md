<div align="center">
<h1>TOML</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.32.5-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-94.3%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## <img alt="" src="./doc/assets/readme-icon-introduction.png" style="display: inline-block;" width=4%/> 简介

TOML 旨在成为一个语义明显且易于阅读的最小化配置文件格式。TOML 被设计成可以无歧义地映射为哈希表。TOML 应该能很容易地被解析成各种语言中的数据结构。
参考toml语法规约地址: https://toml.io/cn/

该项目是仓颉语言实现 TOML v1.0.0 的语言库。参考地址：https://github.com/uiri/toml

### 特性

- 🚀 语义明显**易于阅读**
- 🚀 能**无歧义**地映射为哈希表
- 💪 **易于解析**成各种语言中的数据结构
- 🛠️ 具备实用的原生类型
- 🌍 受到广泛支持

### 路线

<p align="center">
<img src="./doc/assets/milestone.png" width="100%" >
</p>

##    <img alt="" src="./doc/assets/readme-icon-framework.png" style="display: inline-block;" width=4%/> 架构

### 架构图：

<p align="center">
<img src="./doc/assets/framework.png" width="40%" >
</p>

- 通过 load 入口载入 toml 文件

- 区分语法使用不同 parser 进行解析

- 最后生成 DataModel 方便仓颉读取

### 源码目录：

```shell
.
├── README.md
├── doc
│   ├── assets
│   ├── cjcov
│   ├── design.md
│   ├── proposal.md
│   └── xxx_lib.md
├── module.json
├── res
│   ├── example.toml
│   └── multiline_string.toml
├── src
│   ├── decoders
│   ├── enumerations
│   ├── exceptions
│   ├── parser
│   └── utils.cj
└── test
    ├── HLT
    ├── LLT
    └── UT
```

- `doc` 是库的设计文档、提案、库的使用文档、LLT 覆盖率
- `src` 是库源码目录
- `test` 是存放测试用例，包括 HLT 用例、LLT 用例和 UT 用例

### 接口说明

目前只实现对整数、浮点数、字符串、布尔类型字面量的解码。 / TODO

#### class Decoder

```
// 初始化 Decoder
public init()
public init(payload: String)

// 解码 toml 文件， pn 为文件路径
public func load(pn: String)

// 实现解码功能
public func decode()
```

## <img alt="" src="./doc/assets/readme-icon-compile.png" style="display: inline-block;" width=4%/> 编译运行

### 编译

```shell
cpm build
```

### 示例

```shell
from toml import decoders.*

main() {
    let decoder: Decoder = Decoder()
    decoder.load("integer002.toml")
    let a = decoder.decode()
    println(a)
}
```

## <img alt="" src="./doc/assets/readme-icon-contribute.png" style="display: inline-block;" width=4%/> 参与贡献

[@Annlix](https://gitee.com/Annlix) [@chinesebear](https://gitee.com/chinesebear) [@it-worker](https://gitee.com/it-worker)