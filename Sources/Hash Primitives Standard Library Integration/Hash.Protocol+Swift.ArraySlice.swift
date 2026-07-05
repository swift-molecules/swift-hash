#if swift(<6.4)
    // Hash.Protocol+Swift.ArraySlice.swift
    // Conditional conformance for ArraySlice when Element is Copyable.

    extension ArraySlice: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {
        /// Hashes the array slice by feeding its count and elements into the hasher.
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
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
    // conforms `ArraySlice: Hashable where Element: Hashable`, which witnesses
    // `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
    extension ArraySlice: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {}

#endif
