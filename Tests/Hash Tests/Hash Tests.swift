import Hash_Test_Support
import Testing

@Suite struct `Hash Tests` {

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

    @Suite("Integration")
    struct Integration {
        enum User {}

        @Test
        func `Tagged values participate in Hash.Protocol`() {

            let a: User.ID = 42
            let b: User.ID = 42
            #expect(a == b)

            let set: Set<User.ID> = [42, 99, 42]
            #expect(set.count == 2)
        }
    }

    @Suite
    struct `Standard Library` {
        enum Require {}
        enum Typed {}

        @Test
        func `scalar stdlib types conform to Hash.Protocol`() {
            Require.conformance(Int.self)
            Require.conformance(UInt.self)
            Require.conformance(Int8.self)
            Require.conformance(UInt8.self)
            Require.conformance(Bool.self)
            Require.conformance(String.self)
            Require.conformance(Character.self)
            Require.conformance(Double.self)
            Require.conformance(Float.self)
        }

        @Test
        func `container stdlib types conform to Hash.Protocol`() {
            Require.conformance([Int].self)
            Require.conformance(ContiguousArray<Int>.self)
            Require.conformance(CollectionOfOne<Int>.self)
            Require.conformance(EmptyCollection<Int>.self)
            Require.conformance(Set<Int>.self)
            Require.conformance([String: Int].self)
            Require.conformance(Int?.self)
            Require.conformance(Range<Int>.self)
            Require.conformance(ClosedRange<Int>.self)
        }

        @Test
        func `typed hashValue accessor is preserved for stdlib scalars`() {

            let value: Hash.Value = Typed.hashValue(42)
            let same: Hash.Value = Typed.hashValue(42)
            #expect(value == same)
        }

        @Test
        func `Tagged conforms to Hash.Protocol with a typed hashValue`() {
            enum Account {}
            typealias ID = Tagged<Account, Int>
            Require.conformance(ID.self)
            let value: Hash.Value = Typed.hashValue(ID(7))
            let same: Hash.Value = Typed.hashValue(ID(7))
            #expect(value == same)
        }
    }

    @Suite("Performance", .serialized)
    struct Performance {}
}

extension `Hash Tests`.`Edge Case`.Token {
    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.id == rhs.id
    }

    borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension `Hash Tests`.Integration.User {
    typealias ID = Tagged<Self, Int>
}

extension `Hash Tests`.`Standard Library`.Require {

    static func conformance<T: Hash.`Protocol`>(_: T.Type) {}
}

extension `Hash Tests`.`Standard Library`.Typed {

    static func hashValue<T: Hash.`Protocol`>(_ value: T) -> Hash.Value { value.hashValue }
}
