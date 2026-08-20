// Hash.Protocol.swift
// A Swift.Hashable refinement with a typed hash value.
//
// Swift.Hashable natively supports ~Copyable conformers in Swift 6.4.
// See: swift-institute/Research/se-0499-implications-for-equation-hash-comparison-primitives.md

public import Hash_Primitive
public import Tagged_Primitives

extension Hash {
    // `Swift.Hashable: ~Copyable, ~Escapable` per SE-0499 and its `~Escapable`
    // companion (impl PRs #85854/#85891/#86039). The `~Escapable` relaxation
    // reached the bundled stdlib by the 2026-05-07 nightly; on the earlier
    // 2026-03-16 nightly `Swift.Hashable` still required `Escapable`. Build dev
    // verification against `2026-05-07-a` (6.4-dev) or newer.
    /// A type that can be hashed, supporting both `Copyable` and `~Copyable` types.
    ///
    /// Under Swift 6.4+ this *refines* `Swift.Hashable` (which natively supports
    /// `~Copyable` / `~Escapable` conformers per SE-0499) rather than aliasing it.
    /// Refining — not aliasing — preserves the typed `hashValue: Hash.Value`
    /// accessor: a bare `typealias` to
    /// `Swift.Hashable` would resolve `element.hashValue` to `Swift.Int`, breaking
    /// every generic consumer (`Set.Ordered`, `Dictionary`, …) that passes it where
    /// `Hash.Value` is required. See
    /// `swift-institute/Research/se-0499-implications-for-equation-hash-comparison-primitives.md`
    /// Addendum (2026-06-01). Conformers implement only `hash(into:)`/`==`; both the
    /// stdlib `hashValue: Int` and the typed `hashValue: Hash.Value` are defaulted.
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
