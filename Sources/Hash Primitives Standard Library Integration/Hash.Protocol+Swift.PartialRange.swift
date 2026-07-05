// NOTE (Swift 6.4): `PartialRangeFrom`/`PartialRangeThrough`/`PartialRangeUpTo` are NOT
// `Swift.Hashable` and NOT `Swift.Equatable` in the stdlib. Under the 6.4 refining design
// (`Hash.Protocol: Swift.Hashable`), a conformance here would require this package to also
// supply `@retroactive Swift.Equatable` + `@retroactive Swift.Hashable`. `Swift.Equatable`
// conformances for stdlib types are equation-primitives' responsibility, and it gates all
// such bridges out on 6.4 except `Span`. So these conformances stay gated to <6.4 for now.
// Resolution path: add 6.4 `#else` `@retroactive Swift.Equatable` branches in
// equation-primitives (Span precedent), then this file can adopt
// `: Hash.Protocol, @retroactive Swift.Hashable` like Span.
#if swift(<6.4)
    // Hash.Protocol+Swift.PartialRange.swift
    // Conditional conformances for partial range types.

    extension PartialRangeFrom: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {
        /// Hashes the partial range by feeding its bound into the hasher.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            lowerBound.hash(into: &hasher)
        }
    }

    extension PartialRangeThrough: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {
        /// Hashes the partial range by feeding its bound into the hasher.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            upperBound.hash(into: &hasher)
        }
    }

    extension PartialRangeUpTo: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {
        /// Hashes the partial range by feeding its bound into the hasher.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            upperBound.hash(into: &hasher)
        }
    }

#endif
