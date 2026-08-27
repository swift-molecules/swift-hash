public import Tagged

extension Hash {

    public protocol `Protocol`: Swift.Hashable, ~Copyable, ~Escapable {

        borrowing func hash(into hasher: inout Hasher)

        var hashValue: Hash.Value { get }
    }
}

extension Hash.`Protocol` where Self: ~Copyable & ~Escapable {

    @inlinable
    public var hashValue: Hash.Value {
        var hasher = Hasher()
        hash(into: &hasher)
        return Hash.Value(_unchecked: hasher.finalize())
    }
}
