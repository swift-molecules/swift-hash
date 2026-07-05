#if swift(<6.4)
    // Hash.Protocol+Swift.EmptyCollection.swift
    // Conformance for EmptyCollection.

    extension EmptyCollection: Hash.`Protocol` where Element: Hash.`Protocol` {
        /// Hashes the empty collection.
        ///
        /// Hashes a constant since all empty collections are equal.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            hasher.combine(0 as Int)
        }
    }

#else
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib conforms
    // `EmptyCollection: Hashable` unconditionally, which witnesses `hash(into:)`.
    // We add only the refinement; `hashValue: Hash.Value` is defaulted.
    extension EmptyCollection: Hash.`Protocol` where Element: Hash.`Protocol` {}

#endif
