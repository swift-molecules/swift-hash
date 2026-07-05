// NOTE (Swift 6.4): `UnsafeMutableBufferPointer` is NOT `Swift.Hashable` and NOT
// `Swift.Equatable` in the stdlib (unlike `UnsafeMutablePointer`/`UnsafeMutableRawPointer`,
// which conform via `_Pointer`). Under the 6.4 refining design (`Hash.Protocol:
// Swift.Hashable`), a conformance here would require this package to also supply
// `@retroactive Swift.Equatable` + `@retroactive Swift.Hashable`. `Swift.Equatable`
// conformances for stdlib types are equation-primitives' responsibility, and it gates all
// such bridges out on 6.4 except `Span`. So this conformance stays gated to <6.4 for now.
// Resolution path: add a 6.4 `#else` `@retroactive Swift.Equatable` branch in
// equation-primitives (Span precedent), then this file can adopt
// `: Hash.Protocol, @retroactive Swift.Hashable` like Span.
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
