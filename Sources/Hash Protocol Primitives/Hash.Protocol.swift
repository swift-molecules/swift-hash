// Hash.Protocol.swift
// A Hashable fork with ~Copyable support.
//
// SE-0499 (Implemented Swift 6.4) extends Swift.Hashable to natively support
// ~Copyable conformers via borrowing parameters. Under Swift 6.4+, Hash.Protocol
// is a typealias to Swift.Hashable; under Swift <6.4, it remains the fork.
// See: swift-institute/Research/se-0499-implications-for-equation-hash-comparison-primitives.md

public import Hash_Primitive
public import Equation_Primitives
public import Tagged_Primitives

#if swift(>=6.4)

    extension Hash {
        /// A type that can be hashed, supporting both `Copyable` and `~Copyable` types.
        ///
        /// Under Swift 6.4+ this *refines* `Swift.Hashable` (which natively supports
        /// `~Copyable` / `~Escapable` conformers per SE-0499) rather than aliasing it.
        /// Refining — not aliasing — preserves the typed `hashValue: Hash.Value`
        /// accessor that the pre-6.4 fork provided: a bare `typealias` to
        /// `Swift.Hashable` would resolve `element.hashValue` to `Swift.Int`, breaking
        /// every generic consumer (`Set.Ordered`, `Dictionary`, …) that passes it where
        /// `Hash.Value` is required. See
        /// `swift-institute/Research/se-0499-implications-for-equation-hash-comparison-primitives.md`
        /// Addendum (2026-06-01). Conformers implement only `hash(into:)`/`==`; both the
        /// stdlib `hashValue: Int` and the typed `hashValue: Hash.Value` are defaulted.
        // `Swift.Hashable: ~Copyable, ~Escapable` per SE-0499 and its `~Escapable`
        // companion (impl PRs #85854/#85891/#86039). The `~Escapable` relaxation
        // reached the bundled stdlib by the 2026-05-07 nightly; on the earlier
        // 2026-03-16 nightly `Swift.Hashable` still required `Escapable`. Build dev
        // verification against `2026-05-07-a` (6.4-dev) or newer.
        public protocol `Protocol`: Swift.Hashable, ~Copyable, ~Escapable {
            /// Hashes the essential components of this value by feeding them into
            /// the given hasher.
            borrowing func hash(into hasher: inout Hasher)

            /// The typed hash value for this instance.
            var hashValue: Hash.Value { get }
        }
    }

    extension Hash.`Protocol` where Self: ~Copyable & ~Escapable {
        /// The typed hash value for this instance.
        ///
        /// Hash values are not guaranteed to be equal across different executions
        /// of your program. Do not save hash values to use during a future execution.
        @inlinable
        public var hashValue: Hash.Value {
            var hasher = Hasher()
            hash(into: &hasher)
            return Hash.Value(_unchecked: hasher.finalize())
        }
    }

#else

    extension Hash {
        /// A protocol for types that can be hashed, supporting both
        /// `Copyable` and `~Copyable` types.
        ///
        /// This protocol mirrors `Swift.Hashable` but uses `borrowing` parameters
        /// to enable hashing of move-only types without consuming them.
        ///
        /// ## Conforming to Protocol
        ///
        /// Types conforming to `Hash.Protocol` must implement `==` (via `Equation.Protocol`)
        /// and `hash(into:)`:
        ///
        /// ```swift
        /// struct Token: ~Copyable {
        ///     let id: Int
        /// }
        ///
        /// extension Token: Hash.Protocol {
        ///     static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        ///         lhs.id == rhs.id
        ///     }
        ///
        ///     borrowing func hash(into hasher: inout Hasher) {
        ///         hasher.combine(id)
        ///     }
        /// }
        /// ```
        ///
        /// ## Semantic Requirements
        ///
        /// Conforming types must satisfy the hashable contract:
        /// - If `a == b`, then `a.hashValue == b.hashValue`
        /// - The converse is not required: equal hash values do not imply equality
        ///
        /// ## Relationship to Equation.Protocol
        ///
        /// `Hash.Protocol` refines `Equation.Protocol`, inheriting the equality requirement.
        /// This enforces the semantic invariant that equal values must have equal hashes.
        ///
        /// ## Relationship to Swift.Hashable
        ///
        /// Types conforming to `Swift.Hashable` can also conform to `Hash.Protocol`
        /// with minimal additional implementation. The key difference is that
        /// `Hash.Protocol` supports move-only types through `borrowing` semantics.
        public protocol `Protocol`: Equation.`Protocol`, ~Copyable, ~Escapable {
            /// Hashes the essential components of this value by feeding them into
            /// the given hasher.
            ///
            /// - Parameter hasher: The hasher to use when combining the components
            ///   of this value.
            borrowing func hash(into hasher: inout Hasher)
        }
    }

    // MARK: - Default Implementations

    extension Hash.`Protocol` where Self: ~Copyable & ~Escapable {
        /// The hash value for this instance.
        ///
        /// Hash values are not guaranteed to be equal across different executions
        /// of your program. Do not save hash values to use during a future execution.
        @inlinable
        public var hashValue: Hash.Value {
            var hasher = Hasher()
            hash(into: &hasher)
            return Hash.Value(_unchecked: hasher.finalize())
        }
    }

#endif
