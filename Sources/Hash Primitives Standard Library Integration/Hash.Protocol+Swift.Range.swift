// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
// conforms `Range`/`ClosedRange: Hashable where Bound: Hashable`, which witnesses
// `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
extension Range: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {}
extension ClosedRange: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {}
