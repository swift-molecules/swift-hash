// Hash.Protocol+Swift.KeyValuePairs.swift
// Conditional conformance for KeyValuePairs when Key and Value are Copyable.

extension KeyValuePairs: Hash.`Protocol` where Key: Hash.`Protocol` & Copyable, Value: Hash.`Protocol` & Copyable {
    /// Hashes the key-value pairs collection.
    ///
    /// - Note: Uses `copy` to enable iteration on borrowed instance.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        hasher.combine(selfCopy.count)
        for (key, value) in selfCopy {
            key.hash(into: &hasher)
            value.hash(into: &hasher)
        }
    }
}
