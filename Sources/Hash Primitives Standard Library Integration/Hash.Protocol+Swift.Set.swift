// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib conforms
// `Set: Hashable` (Element is Hashable by the type's own constraint), which
// witnesses `hash(into:)`. We add only the refinement; `hashValue: Hash.Value`
// is defaulted.
extension Set: Hash.`Protocol` where Element: Hash.`Protocol` & Copyable {}
