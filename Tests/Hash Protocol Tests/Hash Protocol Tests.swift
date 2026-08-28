import Hash_Protocol
import Testing

@Suite
struct `Hash Protocol Tests` {
    struct Token: ~Copyable, Hash::Hash.`Protocol` {
        let id: Int

        static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            lhs.id == rhs.id
        }

        borrowing func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    @Test
    func `move-only values produce typed hashes`() {
        let token = Token(id: 7)
        let value: Hash::Hash.Value = token.hashValue
        #expect(value == value)
    }
}
