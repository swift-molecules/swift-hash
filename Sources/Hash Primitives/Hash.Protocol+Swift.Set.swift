// Hash.Protocol+Swift.Set.swift
// Conditional conformance for Set when Element is Copyable.

extension Set: Hash.`Protocol` where Element: Hash.`Protocol` & Copyable {
    /// Hashes the set by feeding its components into the hasher.
    ///
    /// The hash is computed using XOR of individual element hashes
    /// to ensure order-independence.
    ///
    /// - Note: XOR-based hashing trades collision resistance for simplicity.
    ///   Per-element `Hasher` construction adds overhead for large sets.
    ///   This is acceptable for correctness but may be optimized in future versions.
    ///
    /// - Note: Uses `copy` to enable iteration on borrowed instance.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        // Use XOR for order-independent hashing
        var combinedHash: Int = 0
        for element in selfCopy {
            var elementHasher = Hasher()
            element.hash(into: &elementHasher)
            combinedHash ^= elementHasher.finalize()
        }
        hasher.combine(selfCopy.count)
        hasher.combine(combinedHash)
    }
}
