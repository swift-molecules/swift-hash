// Hash.Protocol.swift
// A Hashable fork with ~Copyable support.

extension Hash {
    /// A protocol for types that can be hashed, supporting both
    /// `Copyable` and `~Copyable` types.
    ///
    /// This protocol mirrors `Swift.Hashable` but uses `borrowing` parameters
    /// to enable hashing of move-only types without consuming them.
    ///
    /// ## Conforming to Protocol
    ///
    /// Types conforming to `Hash.Protocol` must implement `==` and `hash(into:)`:
    ///
    /// ```swift
    /// struct Token: ~Copyable {
    ///     let id: Int
    /// }
    ///
    /// extension Token: Hash.Protocol {
    ///     static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
    ///         lhs.id == rhs.id
    ///     }
    ///
    ///     borrowing func hash(into hasher: inout Hasher) {
    ///         hasher.combine(id)
    ///     }
    /// }
    /// ```
    ///
    /// ## Semantic Requirements
    ///
    /// Conforming types must satisfy the hashable contract:
    /// - If `a == b`, then `a.hashValue == b.hashValue`
    /// - The converse is not required: equal hash values do not imply equality
    ///
    /// ## Relationship to Swift.Hashable
    ///
    /// Types conforming to `Swift.Hashable` can also conform to `Hash.Protocol`
    /// with minimal additional implementation. The key difference is that
    /// `Hash.Protocol` supports move-only types through `borrowing` semantics.
    public protocol `Protocol`: ~Copyable {
        /// Returns whether the left-hand side is equal to the right-hand side.
        ///
        /// Two values that compare equal must produce the same hash value.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side value.
        ///   - rhs: The right-hand side value.
        /// - Returns: `true` if `lhs` is equal to `rhs`.
        static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool

        /// Hashes the essential components of this value by feeding them into
        /// the given hasher.
        ///
        /// - Parameter hasher: The hasher to use when combining the components
        ///   of this value.
        borrowing func hash(into hasher: inout Hasher)
    }
}

// MARK: - Default Implementations

extension Hash.`Protocol` where Self: ~Copyable {
    /// The hash value for this instance.
    ///
    /// Hash values are not guaranteed to be equal across different executions
    /// of your program. Do not save hash values to use during a future execution.
    @inlinable
    public var hashValue: Int {
        var hasher = Hasher()
        hash(into: &hasher)
        return hasher.finalize()
    }

    /// Returns whether the left-hand side is not equal to the right-hand side.
    @inlinable
    public static func != (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        !(lhs == rhs)
    }
}
