// Hash.Protocol+Swift.Result.swift
// Conditional conformance for Result when Success and Failure are Copyable.

extension Result: Hash.`Protocol` where Success: Hash.`Protocol` & Copyable, Failure: Hash.`Protocol` & Copyable {
    /// Hashes the result by feeding its components into the hasher.
    ///
    /// Hashes a discriminator (0 for `.success`, 1 for `.failure`) followed
    /// by the associated value.
    ///
    /// - Note: Uses `copy` to enable pattern matching on borrowed enum values.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        switch selfCopy {
        case let .success(value):
            hasher.combine(0 as UInt8)
            value.hash(into: &hasher)
        case let .failure(error):
            hasher.combine(1 as UInt8)
            error.hash(into: &hasher)
        }
    }
}
