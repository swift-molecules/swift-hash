// Hash.Protocol+Swift.Dictionary.swift
// Conditional conformance for Dictionary when Key and Value are Copyable.

extension Dictionary: Hash.`Protocol` where Key: Hash.`Protocol` & Copyable, Value: Hash.`Protocol` & Copyable {
    /// Hashes the dictionary by feeding its components into the hasher.
    ///
    /// The hash is computed using XOR of individual key-value pair hashes
    /// to ensure order-independence.
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
        for (key, value) in selfCopy {
            var pairHasher = Hasher()
            key.hash(into: &pairHasher)
            value.hash(into: &pairHasher)
            combinedHash ^= pairHasher.finalize()
        }
        hasher.combine(selfCopy.count)
        hasher.combine(combinedHash)
    }
}
