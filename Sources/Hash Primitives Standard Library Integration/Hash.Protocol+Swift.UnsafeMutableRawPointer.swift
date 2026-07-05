#if swift(<6.4)
    // Hash.Protocol+Swift.UnsafeMutableRawPointer.swift
    // Conformance for UnsafeMutableRawPointer.

    extension UnsafeMutableRawPointer: Hash.`Protocol` {
        /// Hashes the mutable raw pointer by feeding its address into the hasher.
        ///
        /// - Note: Uses `copy` to copy the borrowed pointer value, then hashes
        ///   via `Int(bitPattern:)`.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = unsafe copy self
            hasher.combine(Int(bitPattern: selfCopy))
        }
    }

#else
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; `UnsafeMutableRawPointer`
    // conforms to `Swift.Hashable` via stdlib's `_Pointer` protocol, which witnesses
    // `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
    extension UnsafeMutableRawPointer: @unsafe Hash.`Protocol` {}

#endif
