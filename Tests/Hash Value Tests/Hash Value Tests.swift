import Hash_Value
import Testing

@Suite
struct `Hash Value Tests` {
    @Test
    func `hash values preserve their integer representation`() {
        let value = Hash::Hash.Value(42)
        #expect(value.underlying == 42)
    }

    @Test
    func `equal representations produce equal hash values`() {
        #expect(Hash::Hash.Value(42) == Hash::Hash.Value(42))
        #expect(Hash::Hash.Value(1) != Hash::Hash.Value(2))
    }
}
