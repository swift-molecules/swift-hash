// Swift 6.4+: `Hash.Protocol` refines `Swift.Hashable`; `UnsafeMutableRawPointer`
// conforms to `Swift.Hashable` via stdlib's `_Pointer` protocol, which witnesses
// `hash(into:)`. We add only the refinement; `hashValue: Hash.Value` is defaulted.
extension UnsafeMutableRawPointer: @unsafe Hash.`Protocol` {}
