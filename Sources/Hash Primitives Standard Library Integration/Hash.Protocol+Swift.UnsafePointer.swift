// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; stdlib conforms
// `UnsafePointer: Hashable` (where Pointee: ~Copyable), which witnesses
// `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
extension UnsafePointer: @unsafe Hash.`Protocol` {}
