// Hash.Protocol+Swift.CollectionOfOne.swift
// Conditional conformance for CollectionOfOne when Element is Copyable.

extension CollectionOfOne: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {
    /// Hashes the single element into the hasher.
    ///
    /// - Note: Uses `copy` to enable element access on borrowed instance.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        selfCopy[selfCopy.startIndex].hash(into: &hasher)
    }
}
