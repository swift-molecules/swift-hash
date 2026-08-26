public import Tagged

extension Tagged: Hash.`Protocol`
where Tag: ~Copyable & ~Escapable, Underlying: Hash.`Protocol` & ~Copyable & Escapable {}
