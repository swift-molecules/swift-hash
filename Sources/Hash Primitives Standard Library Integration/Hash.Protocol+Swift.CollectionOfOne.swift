#if swift(<6.4)
    // Hash.Protocol+Swift.CollectionOfOne.swift
    // Conditional conformance for CollectionOfOne when Element is Copyable.

    extension CollectionOfOne: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {
        /// Hashes the single element into the hasher.
        ///
        /// - Note: Uses `copy` to enable element access on borrowed instance.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = copy self
            selfCopy[selfCopy.startIndex].hash(into: &hasher)
        }
    }

#else
    // Swift 6.4+: NO conformance is declared (backport-exclusion pattern).
    //
    // Same wall as Hash.Protocol+Swift.EmptyCollection.swift: on 6.4+ the
    // refinement implies `CollectionOfOne: Hashable`, whose stdlib conformance
    // the 6.4 SDK overlay gates at macOS 27 (unsatisfiable on the `.v26`
    // floor; org.swift.64202607171a; catalog snapshot-noise class 3). Direct
    // witnesses cannot bypass the implied gated conformance, and bare
    // `@available` gating is the forbidden shape. The conformance returns when
    // the platform floor reaches the SDK gate.

#endif
