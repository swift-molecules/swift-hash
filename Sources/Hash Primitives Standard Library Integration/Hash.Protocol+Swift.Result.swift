// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
// conforms `Result: Hashable where Success: Hashable, Failure: Hashable`, which
// witnesses `hash(into:)`. We add only the refinement; `hashValue: Hash.Value`
// is defaulted.
extension Result: Hash.`Protocol`
where Success: Hash.`Protocol` & Copyable, Failure: Hash.`Protocol` & Copyable {}
