#if swift(<6.4)
    // Hash.Protocol+Swift.Dictionary.swift
    // Conditional conformance for Dictionary when Key and Value are Copyable.

    extension Dictionary: Hash.`Protocol`
    where Key: Hash.`Protocol` & Copyable, Value: Hash.`Protocol` & Copyable {
        /// Hashes the dictionary by feeding its components into the hasher.
        ///
        /// The hash is computed using XOR of individual key-value pair hashes
        /// to ensure order-independence.
        ///
        /// - Note: XOR-based hashing trades collision resistance for simplicity.
        ///   Per-element `Hasher` construction adds overhead for large dictionaries.
        ///   This is acceptable for correctness but may be optimized in future versions.
        ///
        /// - Note: Uses `copy` to enable iteration on borrowed instance.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = copy self
            // Use XOR for order-independent hashing
            var combinedHash: Int = 0
            for (key, value) in selfCopy {
                var pairHasher = Hasher()
                key.hash(into: &pairHasher)
                value.hash(into: &pairHasher)
                combinedHash ^= pairHasher.finalize()
            }
            hasher.combine(selfCopy.count)
            hasher.combine(combinedHash)
        }
    }

#else
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
    // conforms `Dictionary: Hashable where Value: Hashable` (Key is Hashable by the
    // type's own constraint), which witnesses `hash(into:)`. We add only the refinement;
    // `hashValue: Hash.Value` is defaulted.
    extension Dictionary: Hash.`Protocol`
    where Key: Hash.`Protocol` & Copyable, Value: Hash.`Protocol` & Copyable {}

#endif
