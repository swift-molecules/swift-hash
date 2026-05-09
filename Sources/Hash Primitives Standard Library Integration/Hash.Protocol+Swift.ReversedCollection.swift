#if swift(<6.4)
    // Hash.Protocol+Swift.ReversedCollection.swift
    // Conditional conformance for ReversedCollection when Element is Copyable.

    extension ReversedCollection: Hash.`Protocol` where Base.Element: Hash.`Protocol` & Copyable {
        /// Hashes the reversed collection.
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

#endif
