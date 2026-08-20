// Hash.Protocol+Swift.Hashable.swift
// Bridge implementations for Swift.Hashable types.
//
// Scalar standard-library types explicitly adopt the Institute refinement.
// Under <6.4, `Hash.Protocol` is a fork refining `Equation.Protocol`; the empty
// conformance is satisfied by each scalar's stdlib `Hashable`/`Equatable` witnesses
// plus the institute `Equation.Protocol` bridge. Under 6.4+, `Hash.Protocol` refines
// `Swift.Hashable`, so the empty conformance is satisfied directly by the scalar's
// stdlib `hash(into:)` (borrowing under SE-0499); `hashValue: Hash.Value` is defaulted
// in the `Hash.Protocol` extension. The body is identical in both worlds, so no gate
// is needed — and un-gating is exactly what restores these conformances on 6.4.

// MARK: - Integer Conformances

extension Int: Hash.`Protocol` {}
extension Int8: Hash.`Protocol` {}
extension Int16: Hash.`Protocol` {}
extension Int32: Hash.`Protocol` {}
extension Int64: Hash.`Protocol` {}
extension UInt: Hash.`Protocol` {}
extension UInt8: Hash.`Protocol` {}
extension UInt16: Hash.`Protocol` {}
extension UInt32: Hash.`Protocol` {}
extension UInt64: Hash.`Protocol` {}

// MARK: - Other Standard Library Types

extension Bool: Hash.`Protocol` {}
extension String: Hash.`Protocol` {}
extension Character: Hash.`Protocol` {}
extension Double: Hash.`Protocol` {}
extension Float: Hash.`Protocol` {}
