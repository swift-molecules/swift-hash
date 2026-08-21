extension Result: Hash.`Protocol`
where Success: Hash.`Protocol` & Copyable, Failure: Hash.`Protocol` & Copyable {}
