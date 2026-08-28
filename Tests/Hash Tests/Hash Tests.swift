import Hash
import Testing

@Suite
struct `Hash Tests` {
    @Test
    func `base hash namespace is empty`() {
        #expect(MemoryLayout<Hash::Hash>.size == 0)
    }
}
