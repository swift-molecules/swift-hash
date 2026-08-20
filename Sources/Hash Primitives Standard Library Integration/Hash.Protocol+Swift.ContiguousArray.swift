// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
// conforms `ContiguousArray: Hashable where Element: Hashable`, which witnesses
// `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
extension ContiguousArray: Hash.`Protocol` where Element: Hash.`Protocol`, Element: Copyable {}
