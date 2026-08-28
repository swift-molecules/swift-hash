extension Span: Hash::Hash.`Protocol`, @retroactive Swift.Hashable
where Element: Hash::Hash.`Protocol` & ~Copyable {

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
