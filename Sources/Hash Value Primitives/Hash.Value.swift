// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Hash_Primitive
public import Tagged_Primitives

extension Hash {
    /// A hash value produced by ``Hash/Protocol/hashValue``.
    ///
    /// Wraps the raw `Int` output of `Hasher.finalize()` in a typed wrapper
    /// to prevent accidental misuse of non-hash integers as hash values.
    ///
    /// ```swift
    /// let value: Hash.Value = element.hashValue   // typed
    /// let raw: Int = value.underlying             // explicit extraction
    /// ```
    public typealias Value = Tagged<Hash, Int>
}
