public import Hash_Value

extension Hash::Hash {

    public protocol `Protocol`: Swift.Hashable, ~Copyable, ~Escapable {

        borrowing func hash(into hasher: inout Hasher)

        var hashValue: Hash::Hash.Value { get }
    }
}

extension Hash::Hash.`Protocol` where Self: ~Copyable & ~Escapable {

    @inlinable
    public var hashValue: Hash::Hash.Value {
        var hasher = Hasher()
        hash(into: &hasher)
        return Hash::Hash.Value(_unchecked: hasher.finalize())
    }
}
