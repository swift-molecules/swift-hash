extension Result: Hash::Hash.`Protocol`
where Success: Hash::Hash.`Protocol` & Copyable, Failure: Hash::Hash.`Protocol` & Copyable {}
