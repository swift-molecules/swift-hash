// NOTE (Swift 6.4): `ReversedCollection` is NOT `Swift.Hashable` and NOT `Swift.Equatable`
// in the stdlib (only its `.Index` is `Hashable`). Under the 6.4 refining design
// (`Hash.Protocol: Swift.Hashable`), a conformance here would require this package to also
// supply `@retroactive Swift.Equatable` + `@retroactive Swift.Hashable`. `Swift.Equatable`
// conformances for stdlib types are equation-primitives' responsibility, and it gates all
// such bridges out on 6.4 except `Span`. So this conformance stays gated to <6.4 for now.
// Resolution path: add a 6.4 `#else` `@retroactive Swift.Equatable` branch in
// equation-primitives (Span precedent), then this file can adopt
// `: Hash.Protocol, @retroactive Swift.Hashable` like Span.
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
