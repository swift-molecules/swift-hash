#if swift(<6.4)
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
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = copy self
            switch selfCopy {
            case .none:
                hasher.combine(0 as UInt8)

            case .some(let wrapped):
                hasher.combine(1 as UInt8)
                wrapped.hash(into: &hasher)
            }
        }
    }

#else
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
    // conforms `Optional: Hashable where Wrapped: Hashable`, which witnesses
    // `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
    extension Optional: Hash.`Protocol` where Wrapped: Hash.`Protocol`, Wrapped: Copyable {}

#endif
