#if swift(<6.4)
    // Hash.Protocol+Swift.Array.swift
    // Conditional conformance for Array when Element is Copyable.

    extension Swift.Array: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {
        /// Hashes the array by feeding its count and elements into the hasher.
        ///
        /// - Note: Uses `copy` to enable iteration on borrowed instance.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = copy self
            hasher.combine(selfCopy.count)
            for element in selfCopy {
                element.hash(into: &hasher)
            }
        }
    }

#else
    // Hash.Protocol+Swift.Array.swift
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`. `Swift.Array` already
    // conditionally conforms to `Swift.Hashable where Element: Hashable`, which
    // witnesses `hash(into:)`; `Element: Hash.Protocol` implies `Element: Hashable`,
    // so that stdlib conformance satisfies the inherited requirement. We add only the
    // `Hash.Protocol` refinement (empty body); `hashValue: Hash.Value` is defaulted.
    extension Swift.Array: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {}

#endif
