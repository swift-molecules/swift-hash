// Hash.Protocol+Swift.Span.swift
// `Hash.Protocol` refines `Swift.Hashable`; `Swift.Span` is `~Escapable`
// and is not stdlib-`Hashable`, so the Institute supplies both. A stdlib type
// conforming to an in-package protocol that refines a stdlib one must state both:
// `: Hash.Protocol, @retroactive Swift.Hashable`. `Span: Swift.Equatable` (required
// by `Swift.Hashable`) comes from equation-primitives' SLI.
extension Span: Hash.`Protocol`, @retroactive Swift.Hashable
where Element: Hash.`Protocol` & ~Copyable {
    /// Hashes the span by feeding its count and each element into the hasher, in order.
    @inlinable
    @_disfavoredOverload
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        var index = 0
        while index < count {
            self[index].hash(into: &hasher)
            index += 1
        }
    }
}
