// NOTE (Swift 6.4): `KeyValuePairs` is NOT `Swift.Hashable` and NOT `Swift.Equatable`
// in the stdlib. Under the 6.4 refining design (`Hash.Protocol: Swift.Hashable`), a
// conformance here would require this package to also supply `@retroactive Swift.Equatable`
// + `@retroactive Swift.Hashable`. `Swift.Equatable` conformances for stdlib types are
// equation-primitives' responsibility, and it gates all such bridges out on 6.4 except
// `Span`. So this conformance stays gated to <6.4 for now. Resolution path: add a 6.4
// `#else` `@retroactive Swift.Equatable` branch in equation-primitives (Span precedent),
// then this file can adopt `: Hash.Protocol, @retroactive Swift.Hashable` like Span.
#if swift(<6.4)
    // Hash.Protocol+Swift.KeyValuePairs.swift
    // Conditional conformance for KeyValuePairs when Key and Value are Copyable.

    extension KeyValuePairs: Hash.`Protocol` where Key: Hash.`Protocol` & Copyable, Value: Hash.`Protocol` & Copyable {
        /// Hashes the key-value pairs collection.
        ///
        /// - Note: Uses `copy` to enable iteration on borrowed instance.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = copy self
            hasher.combine(selfCopy.count)
            for (key, value) in selfCopy {
                key.hash(into: &hasher)
                value.hash(into: &hasher)
            }
        }
    }

#endif
