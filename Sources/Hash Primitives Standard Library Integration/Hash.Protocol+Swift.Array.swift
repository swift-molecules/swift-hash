// Hash.Protocol+Swift.Array.swift
// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`. `Swift.Array` already
// conditionally conforms to `Swift.Hashable where Element: Hashable`, which
// witnesses `hash(into:)`; `Element: Hash.Protocol` implies `Element: Hashable`,
// so that stdlib conformance satisfies the inherited requirement. We add only the
// `Hash.Protocol` refinement (empty body); `hashValue: Hash.Value` is defaulted.
extension Swift.Array: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {}
