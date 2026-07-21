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
    // Swift 6.4+: NO conformance is declared (backport-exclusion pattern).
    //
    // `Hash.Protocol` refines `Swift.Hashable` on 6.4+, so a conformance here
    // IMPLIES `EmptyCollection: Hashable` — and the 6.4 SDK overlay gates the
    // stdlib's `EmptyCollection: Hashable` at macOS 27, which the ecosystem's
    // `.v26` platform floor cannot satisfy (`error: conformance of
    // 'EmptyCollection<Element>' to 'Hashable' is only available in macOS 27.0
    // or newer`, first hit on org.swift.64202607171a; compiler-bug catalog
    // "snapshot-noise class 3" — forward-versioned stdlib retroactive-
    // conformance availability gate, now shipping in release/6.4.x).
    // Implementing the witnesses directly cannot help: the implied `Hashable`
    // requirement can only be satisfied by the stdlib's gated conformance, and
    // `@available`-gating this extension would drop the capability below
    // macOS 27 on the .v26 floor. The conformance returns when the floor
    // reaches the SDK gate.

#endif
