#if swift(<6.4)
    // Hash.Protocol+Swift.Span.swift
    // Conditional conformance for Span — element-wise hashing.

    extension Span: Hash.`Protocol` where Element: Hash.`Protocol` & ~Copyable {
        /// Hashes the span by feeding its count and each element into the hasher, in
        /// order — element-wise, like `Array`.
        ///
        /// Each element is hashed via the `borrowing` `hash(into:)`, so this supports
        /// `~Copyable` elements and never copies an element out of the span.
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

#else
    // Hash.Protocol+Swift.Span.swift
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; `Swift.Span` is `~Escapable`
    // and is NOT stdlib-`Hashable`, so the institute supplies both (the pre-6.4 fork
    // branch guarded this out, which dropped Span hashing on 6.4+). A stdlib type
    // conforming to an in-package protocol that refines a stdlib one must state both:
    // `: Hash.Protocol, @retroactive Swift.Hashable`. `Span: Swift.Equatable` (required
    // by `Swift.Hashable`) comes from equation-primitives' SLI.
    extension Span: Hash.`Protocol`, @retroactive Swift.Hashable where Element: Hash.`Protocol` & ~Copyable {
        /// Hashes the span by feeding its count and each element into the hasher, in order.
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
