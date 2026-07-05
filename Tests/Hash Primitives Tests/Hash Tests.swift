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

    // MARK: - Standard Library conformance (regression guard)

    /// Guards that the Standard-Library-Integration bridges make stdlib types conform to
    /// the refining `Hash.Protocol`. These conformances are load-bearing for ~90 downstream
    /// packages. They regressed on Swift 6.4 when the design moved from a `typealias` to a
    /// refining protocol but the SLI module stayed gated `#if swift(<6.4)`. This suite is
    /// unconditional: it must hold on both the pre-6.4 fork and the 6.4+ refining design.
    @Suite("Standard Library")
    struct StandardLibrary {
        // Compile-time conformance witnesses: these calls fail to type-check if the
        // corresponding `Hash.Protocol` conformance is absent (the exact 6.4 regression).
        static func requireConformance<T: Hash.`Protocol`>(_: T.Type) {}

        // The typed `hashValue: Hash.Value` accessor must remain typed (not erased to
        // `Swift.Int`) for generic consumers — the whole reason the design refines rather
        // than aliases `Swift.Hashable`.
        static func typedHashValue<T: Hash.`Protocol`>(_ value: T) -> Hash.Value { value.hashValue }

        @Test
        func `scalar stdlib types conform to Hash.Protocol`() {
            Self.requireConformance(Int.self)
            Self.requireConformance(UInt.self)
            Self.requireConformance(Int8.self)
            Self.requireConformance(UInt8.self)
            Self.requireConformance(Bool.self)
            Self.requireConformance(String.self)
            Self.requireConformance(Character.self)
            Self.requireConformance(Double.self)
            Self.requireConformance(Float.self)
        }

        @Test
        func `container stdlib types conform to Hash.Protocol`() {
            Self.requireConformance([Int].self)
            Self.requireConformance(ContiguousArray<Int>.self)
            Self.requireConformance(Set<Int>.self)
            Self.requireConformance([String: Int].self)
            Self.requireConformance(Int?.self)
            Self.requireConformance(Range<Int>.self)
            Self.requireConformance(ClosedRange<Int>.self)
        }

        @Test
        func `typed hashValue accessor is preserved for stdlib scalars`() {
            // In a generic context constrained to `Hash.Protocol`, `.hashValue` must yield
            // the typed `Hash.Value`, not `Swift.Int`. The return type below is the proof.
            let value: Hash.Value = Self.typedHashValue(42)
            let same: Hash.Value = Self.typedHashValue(42)
            #expect(value == same)
        }

        @Test
        func `Tagged conforms to Hash.Protocol with a typed hashValue`() {
            enum Account {}
            typealias ID = Tagged<Account, Int>
            Self.requireConformance(ID.self)
            let value: Hash.Value = Self.typedHashValue(ID(7))
            let same: Hash.Value = Self.typedHashValue(ID(7))
            #expect(value == same)
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
