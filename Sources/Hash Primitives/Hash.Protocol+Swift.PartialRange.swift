// Hash.Protocol+Swift.PartialRange.swift
// Conditional conformances for partial range types.

extension PartialRangeFrom: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {
    /// Hashes the partial range by feeding its bound into the hasher.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        lowerBound.hash(into: &hasher)
    }
}

extension PartialRangeThrough: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {
    /// Hashes the partial range by feeding its bound into the hasher.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        upperBound.hash(into: &hasher)
    }
}

extension PartialRangeUpTo: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {
    /// Hashes the partial range by feeding its bound into the hasher.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        upperBound.hash(into: &hasher)
    }
}
