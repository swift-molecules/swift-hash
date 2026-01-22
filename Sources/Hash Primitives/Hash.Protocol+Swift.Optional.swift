// Hash.Protocol+Swift.Optional.swift
// Conditional conformance for Optional when Wrapped is Copyable.

extension Optional: Hash.`Protocol` where Wrapped: Hash.`Protocol`, Wrapped: Copyable {
    /// Hashes the optional value by feeding its components into the hasher.
    ///
    /// Hashes a discriminator (0 for `.none`, 1 for `.some`) followed by
    /// the wrapped value if present.
    ///
    /// - Note: Uses `copy` to enable pattern matching on borrowed enum values.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        switch selfCopy {
        case .none:
            hasher.combine(0 as UInt8)
        case let .some(wrapped):
            hasher.combine(1 as UInt8)
            wrapped.hash(into: &hasher)
        }
    }
}
