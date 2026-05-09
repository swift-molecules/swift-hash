#if swift(<6.4)
    // Hash.Protocol+Identity.Tagged.swift
    // Hash.Protocol conformance for Tagged types.

    public import Tagged_Primitives

    extension Tagged: Hash.`Protocol` where Tag: ~Copyable, Underlying: ~Copyable & Hash.`Protocol` {
        /// Hashes the essential components of this tagged value by feeding them into
        /// the given hasher.
        ///
        /// Hashes the underlying value using `Hash.Protocol` semantics,
        /// enabling hashing for `~Copyable` underlying values without consuming them.
        ///
        /// - Note: Uses `@_disfavoredOverload` to prefer `Swift.Hashable` when Underlying
        ///   conforms to both. This ensures Copyable types use the standard library method.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            underlying.hash(into: &hasher)
        }
    }

#endif
