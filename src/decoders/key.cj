package decoders

from std import unicode.*

public class Key <: ToString & Hashable & Equatable<Key> {
    var name: String = "" // 当前键的名称
    var next: ArrayList<Key> = ArrayList<Key>([]) // 下一个键的内容

    public init(name: String, next: Key) {
        this.name = name
        this.next.add(next)
    }

    public init() {

    }

    public func toString(): String {
        var str: String = ""
        let len: UInt64 = UInt64(next.size())
        println(len)
        // if (len == 0) {
        //     str = name
        // } else if (len == 1) {
        //     str = name + "." + next.toString()
        // } else if (len > 1) {
        //     let nextsStr: ArrayList<String> = ArrayList<String>(len)
        //     for (item in next) {
        //         nextsStr.add(name + "." + item.toString())
        //     }
        //     str = String.join(Array<String>(nextsStr), Symbols.DOT)
        // }
        str
    }

    public func hashCode(): Int64 {
        toString().hashCode()
    }

    public operator func ==(rhs: Key): Bool {
        toString().equals(rhs.toString())
    }

    public operator func !=(rhs: Key): Bool {
        !toString().equals(rhs.toString())
    }

    // public mut func add(nameItem: String) {
    //     name.add(nameItem)
    // }

    public func setName(n: String): Unit {
        name = n
    }
}