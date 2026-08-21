extension EmptyCollection: Hash.`Protocol` where Element: Hash.`Protocol` {

    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(0 as Int)
    }
}
