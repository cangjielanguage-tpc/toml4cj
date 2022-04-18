package decoders

from std import unicode.*

public record Key <: ToString & Hashable & Equatable<Key> {
    var name: ArrayList<String>

    public init(name: Array<String>) {
        this.name = ArrayList<String>(name)
    }

    public init() {
        this.name = ArrayList<String>(1)
    }

    public func toString(): String {
        String.join(Array<String>(name), delimiter: Symbols.DOT)
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

    public mut func add(nameItem: String) {
        name.add(nameItem)
    }
}