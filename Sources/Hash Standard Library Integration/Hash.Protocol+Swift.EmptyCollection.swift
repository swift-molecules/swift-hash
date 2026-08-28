extension EmptyCollection: Hash::Hash.`Protocol` where Element: Hash::Hash.`Protocol` {

    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(0 as Int)
    }
}
