// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
// conforms `Optional: Hashable where Wrapped: Hashable`, which witnesses
// `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
extension Optional: Hash.`Protocol` where Wrapped: Hash.`Protocol`, Wrapped: Copyable {}
