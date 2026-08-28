import Hash_Tagged
import Tagged_Standard_Library_Integration
import Testing

@Suite
struct `Hash Tagged Tests` {
    enum User {}
    typealias ID = Tagged::Tagged<User, Int>

    @Test
    func `tagged hashable values conform to Hash.Protocol`() {
        func require<T: Hash::Hash.`Protocol`>(_: T.Type) {}
        require(ID.self)
        let values: Set<ID> = [42, 99, 42]
        #expect(values.count == 2)
    }
}
