#if swift(<6.4)
    // Hash.Protocol+Swift.UnsafeMutableBufferPointer.swift
    // Conditional conformance for UnsafeMutableBufferPointer.

    extension UnsafeMutableBufferPointer: Hash.`Protocol` {
        /// Hashes the mutable buffer pointer by feeding its base address and count into the hasher.
        ///
        /// - Note: Uses `copy` to copy the borrowed buffer pointer value, then hashes
        ///   the base address via `Int(bitPattern:)` and the count.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = unsafe copy self
            let addr = unsafe selfCopy.baseAddress.map { Int(bitPattern: $0) }
            hasher.combine(addr)
            hasher.combine(selfCopy.count)
        }
    }

#endif
