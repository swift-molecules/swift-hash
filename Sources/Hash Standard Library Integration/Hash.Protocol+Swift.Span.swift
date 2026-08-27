extension Span: Hash.`Protocol`, @retroactive Swift.Hashable
where Element: Hash.`Protocol` & ~Copyable {

    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        var index = 0
        while index < count {
            self[index].hash(into: &hasher)
            index += 1
        }
    }
}

extension Span: @retroactive Swift.Equatable
where Element: Hash.`Protocol` & ~Copyable {

    @inlinable
    @_disfavoredOverload
    public static func == (lhs: Span, rhs: Span) -> Bool {
        guard lhs.count == rhs.count else { return false }
        var index = 0
        while index < lhs.count {
            guard lhs[index] == rhs[index] else { return false }
            index += 1
        }
        return true
    }
}
