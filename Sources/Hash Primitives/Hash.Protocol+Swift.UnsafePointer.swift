// Hash.Protocol+Swift.UnsafePointer.swift
// Conditional conformance for UnsafePointer.

extension UnsafePointer: Hash.`Protocol` {
    /// Hashes the typed pointer by feeding its address into the hasher.
    ///
    /// - Note: Uses `copy` to copy the borrowed pointer value, converts to
    ///   `UnsafeRawPointer`, then hashes via `Int(bitPattern:)`.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        let selfCopy = copy self
        hasher.combine(unsafe Int(bitPattern: UnsafeRawPointer(selfCopy)))
    }
}
