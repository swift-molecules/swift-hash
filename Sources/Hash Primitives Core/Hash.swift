// Hash.swift
// Namespace for hashing primitives.

/// Namespace for hashing-related types and protocols.
///
/// `Hash` provides protocols and utilities for hashing values, with full support
/// for `~Copyable` types through `borrowing` semantics.
///
/// ## Key Types
///
/// - ``Hash/Protocol``: A hashable protocol supporting `~Copyable` types.
///
/// ## Example
///
/// ```swift
/// struct Token: ~Copyable, Hash.Protocol {
///     let id: Int
///
///     static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
///         lhs.id == rhs.id
///     }
///
///     borrowing func hash(into hasher: inout Hasher) {
///         hasher.combine(id)
///     }
/// }
/// ```
public enum Hash: Sendable {}
