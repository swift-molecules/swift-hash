// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib already conditionally
// conforms `Dictionary: Hashable where Value: Hashable` (Key is Hashable by the
// type's own constraint), which witnesses `hash(into:)`. We add only the refinement;
// `hashValue: Hash.Value` is defaulted.
extension Dictionary: Hash.`Protocol`
where Key: Hash.`Protocol` & Copyable, Value: Hash.`Protocol` & Copyable {}
