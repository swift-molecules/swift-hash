extension Range: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {}
extension ClosedRange: Hash.`Protocol` where Bound: Hash.`Protocol` & Copyable {}
