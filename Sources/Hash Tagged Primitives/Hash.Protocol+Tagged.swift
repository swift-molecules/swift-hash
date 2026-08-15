// Hash.Protocol+Tagged.swift
// Hash.Protocol conformance for Tagged types.

public import Tagged_Primitives

#if swift(<6.4)

    extension Tagged: Hash.`Protocol`
    where Tag: ~Copyable & ~Escapable, Underlying: ~Copyable & Hash.`Protocol` {
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

#else

    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`. `Tagged` already conditionally
    // conforms to `Swift.Hashable` (see swift-tagged-primitives `Tagged.swift`, the
    // `#if compiler(>=6.4)` branch): `Tagged: Hashable where Tag: ~Copyable & ~Escapable,
    // Underlying: Hashable & ~Copyable & Escapable`. That conformance witnesses
    // `hash(into:)`; the constraints below mirror it exactly so the inherited
    // `Swift.Hashable` requirement is satisfied. We add only the `Hash.Protocol`
    // refinement (empty body); `hashValue: Hash.Value` is defaulted.
    extension Tagged: Hash.`Protocol`
    where Tag: ~Copyable & ~Escapable, Underlying: Hash.`Protocol` & ~Copyable & Escapable {}

#endif
