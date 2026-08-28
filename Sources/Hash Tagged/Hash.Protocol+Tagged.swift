public import Tagged

extension Tagged::Tagged: Hash::Hash.`Protocol`
where Tag: ~Copyable & ~Escapable, Underlying: Hash::Hash.`Protocol` & ~Copyable & Escapable {}
