public import Tagged_Primitives

extension Tagged: Hash.`Protocol`
where Tag: ~Copyable & ~Escapable, Underlying: Hash.`Protocol` & ~Copyable & Escapable {}
