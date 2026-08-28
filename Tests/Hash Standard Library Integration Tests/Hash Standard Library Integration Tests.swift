import Hash_Standard_Library_Integration
import Testing

@Suite
struct `Hash Standard Library Integration Tests` {
    @Test
    func `scalar and collection types conform to Hash.Protocol`() {
        func require<T: Hash::Hash.`Protocol`>(_: T.Type) {}
        require(Int.self)
        require(String.self)
        require([Int].self)
        require(Set<Int>.self)
        require(Int?.self)
    }

    @Test
    func `standard-library values expose typed hash values`() {
        let value: Hash::Hash.Value = 42.hashValue
        #expect(value == value)
    }
}
