#if swift(<6.4)
    // Hash.Protocol+Swift.UnsafePointer.swift
    // Conditional conformance for UnsafePointer.

    extension UnsafePointer: Hash.`Protocol` {
        /// Hashes the typed pointer by feeding its address into the hasher.
        ///
        /// - Note: Uses `copy` to copy the borrowed pointer value, converts to
        ///   `UnsafeRawPointer`, then hashes via `Int(bitPattern:)`.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = unsafe copy self
            hasher.combine(unsafe Int(bitPattern: UnsafeRawPointer(selfCopy)))
        }
    }

#else
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib conforms
    // `UnsafePointer: Hashable` (where Pointee: ~Copyable), which witnesses
    // `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
    extension UnsafePointer: @unsafe Hash.`Protocol` {}

#endif
