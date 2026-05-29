#if swift(<6.4)
    // Hash.Protocol+Swift.Span.swift
    // Conditional conformance for Span — element-wise hashing.

    extension Span: Hash.`Protocol` where Element: Hash.`Protocol` {
        /// Hashes the span by feeding its count and each element into the hasher, in
        /// order — element-wise, like `Array`. Each element is hashed via the
        /// `borrowing` `hash(into:)`, so this supports `~Copyable` elements and never
        /// copies an element out of the span.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            hasher.combine(count)
            var index = 0
            while index < count {
                self[index].hash(into: &hasher)
                index += 1
            }
        }
    }

#endif
