public import Hash
public import Tagged

extension Hash::Hash {

    public typealias Value = Tagged::Tagged<Hash::Hash, Int>
}
