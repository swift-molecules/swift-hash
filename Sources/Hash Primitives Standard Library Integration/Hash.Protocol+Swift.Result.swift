#if swift(<6.4)
    // Hash.Protocol+Swift.Result.swift
    // Conditional conformance for Result when Success and Failure are Copyable.

    extension Result: Hash.`Protocol` where Success: Hash.`Protocol` & Copyable, Failure: Hash.`Protocol` & Copyable {
        /// Hashes the result by feeding its components into the hasher.
        ///
        /// Hashes a discriminator (0 for `.success`, 1 for `.failure`) followed
        /// by the associated value.
        ///
        /// - Note: Uses `copy` to enable pattern matching on borrowed enum values.
        ///
        /// - Parameter hasher: The hasher to use when combining the components.
        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            let selfCopy = copy self
            switch selfCopy {
            case .success(let value):
                hasher.combine(0 as UInt8)
                value.hash(into: &hasher)

            case .failure(let error):
                hasher.combine(1 as UInt8)
                error.hash(into: &hasher)
            }
        }
    }

#else
    // Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
    // conforms `Result: Hashable where Success: Hashable, Failure: Hashable`, which
    // witnesses `hash(into:)`. We add only the refinement; `hashValue: Hash.Value`
    // is defaulted.
    extension Result: Hash.`Protocol`
    where Success: Hash.`Protocol` & Copyable, Failure: Hash.`Protocol` & Copyable {}

#endif
