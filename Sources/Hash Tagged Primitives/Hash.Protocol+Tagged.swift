// Hash.Protocol+Tagged.swift
// Hash.Protocol conformance for Tagged types.

public import Tagged_Primitives

// `Hash.Protocol` refines `Swift.Hashable`. `Tagged` conforms to
// `Swift.Hashable` where `Tag: ~Copyable & ~Escapable,
// Underlying: Hashable & ~Copyable & Escapable`. That conformance witnesses
// `hash(into:)`; the constraints below mirror it exactly so the inherited
// `Swift.Hashable` requirement is satisfied. We add only the `Hash.Protocol`
// refinement (empty body); `hashValue: Hash.Value` is defaulted.
extension Tagged: Hash.`Protocol`
where Tag: ~Copyable & ~Escapable, Underlying: Hash.`Protocol` & ~Copyable & Escapable {}
