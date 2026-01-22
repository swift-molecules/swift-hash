// Hash.Protocol+Swift.Range.swift
// Conditional conformance for Range when Bound is Copyable.

extension Range: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {
    /// Hashes the range by feeding its bounds into the hasher.
    ///
    /// - Note: Uses `copy` to enable property access on borrowed instance.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        selfCopy.lowerBound.hash(into: &hasher)
        selfCopy.upperBound.hash(into: &hasher)
    }
}

extension ClosedRange: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {
    /// Hashes the closed range by feeding its bounds into the hasher.
    ///
    /// - Note: Uses `copy` to enable property access on borrowed instance.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        selfCopy.lowerBound.hash(into: &hasher)
        selfCopy.upperBound.hash(into: &hasher)
    }
}
