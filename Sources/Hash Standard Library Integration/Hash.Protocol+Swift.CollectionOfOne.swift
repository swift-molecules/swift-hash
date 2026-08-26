extension CollectionOfOne: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {

    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        selfCopy[selfCopy.startIndex].hash(into: &hasher)
    }
}
