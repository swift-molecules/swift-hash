extension CollectionOfOne: Hash::Hash.`Protocol` where Element: Hash::Hash.`Protocol`, Element: Copyable {

    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        selfCopy[selfCopy.startIndex].hash(into: &hasher)
    }
}
