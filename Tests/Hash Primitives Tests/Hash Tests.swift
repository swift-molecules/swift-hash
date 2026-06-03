// Hash Tests.swift
// Tests for Hash.Value, Hash.Protocol conformance, and the equals/hashCode contract.

import Hash_Primitives_Test_Support
import Testing

@Suite("Hash")
struct Test {

    // MARK: - Hash.Value typed wrapper

    @Suite("Unit")
    struct Unit {
        @Test
        func `Hash.Value wraps an Int via Tagged`() {
            let raw: Int = 42
            let value: Hash.Value = .init(raw)
            #expect(value.underlying == 42)
        }

        @Test
        func `Hash.Value distinct values are unequal`() {
            let a: Hash.Value = .init(1)
            let b: Hash.Value = .init(2)
            #expect(a != b)
        }

        @Test
        func `Hash.Value equal values are equal`() {
            let a: Hash.Value = .init(42)
            let b: Hash.Value = .init(42)
            #expect(a == b)
        }
    }

    // MARK: - ~Copyable conformance

    @Suite
    struct `Edge Case` {
        struct Token: ~Copyable, Hash.`Protocol` {
            let id: Int
        }

        @Test
        func `~Copyable type conforms with borrowing == and hash(into:)`() {
            let a = Token(id: 1)
            let b = Token(id: 1)
            let equal: Bool = a == b
            #expect(equal == true)
        }

        @Test
        func `~Copyable type produces consistent hash for equal values`() {
            // equals/hashCode contract: a == b implies hash(a) == hash(b).
            // Compute hashes via two separate hashers and compare.
            let a = Token(id: 7)
            let b = Token(id: 7)

            var hasher1 = Hasher()
            a.hash(into: &hasher1)
            let h1 = hasher1.finalize()

            var hasher2 = Hasher()
            b.hash(into: &hasher2)
            let h2 = hasher2.finalize()

            #expect(h1 == h2)
        }
    }

    // MARK: - Tagged conformance

    @Suite("Integration")
    struct Integration {
        enum User {}

        @Test
        func `Tagged values participate in Hash.Protocol`() {
            // The fork branch declares Tagged: Hash.Protocol where Underlying: Hash.Protocol.
            // The typealias branch (Swift 6.4+) inherits Hashable from Tagged's stdlib conformance.
            let a: User.ID = 42
            let b: User.ID = 42
            #expect(a == b)

            // Hashable participation in a Set
            let set: Set<User.ID> = [42, 99, 42]
            #expect(set.count == 2)
        }
    }

    @Suite("Performance", .serialized)
    struct Performance {}
}

extension Test.`Edge Case`.Token {
    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.id == rhs.id
    }

    borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Test.Integration.User {
    typealias ID = Tagged<Self, Int>
}
