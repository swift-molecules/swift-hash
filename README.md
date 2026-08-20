# Hash Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-primitives/swift-hash-primitives/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-hash-primitives/actions/workflows/ci.yml)

`Hash.Value` — a typed wrapper for hash output that prevents accidental misuse of arbitrary integers as hashes — and `Hash.Protocol`, a hashing protocol that admits `~Copyable` types via `borrowing` parameters. Mirrors `Swift.Hashable` and, on Swift 6.4 and later, *is* `Swift.Hashable` via a namespace typealias once [SE-0499](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0499-support-non-copyable-simple-protocols.md) lands at your floor.

Refines [`swift-equation-primitives`](https://github.com/swift-primitives/swift-equation-primitives) at the type level — encoding the equals/hashCode contract (equal values must produce equal hashes) as a compile-time invariant.

---

## Key Features

- **Typed hash output** — `Hash.Value = Tagged<Hash, Int>` distinguishes hash values from arbitrary integers. The phantom `Hash` tag (the namespace itself, reused as the tag) prevents accidental misuse — hashes can't be confused with offsets, counts, or magic constants.
- **Move-only hashing** — `Hash.Protocol` lets `~Copyable` types implement `hash(into:)` with `borrowing self`. The `==` requirement is inherited from `Equation.Protocol`.
- **Equals/hashCode contract at the type level** — `Hash.Protocol: Equation.Protocol` enforces that hashable types support equality. Equal values must produce equal hashes (the semantic invariant remains your responsibility, but the type system stops you from declaring a hash without an equality).
- **Stdlib bridges included** — Standard Library Integration target re-conforms common stdlib `Hashable` types under Swift <6.4. On Swift 6.4+ those bridges become no-ops because `Hash.Protocol` IS `Swift.Hashable`.
- **SE-0499 dual-mode** — Under Swift <6.4, the package ships its own protocol fork. Under Swift 6.4+, `Hash.Protocol` is a typealias to `Swift.Hashable`. Conformances written today work on both compiler families.

---

## Quick Start

A move-only token type conforms with `borrowing` `==` and `hash(into:)`:

```swift
import Hash_Primitives

struct Token: ~Copyable {
    let id: Int
}

extension Token: Hash.`Protocol` {
    static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        lhs.id == rhs.id
    }

    borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
```

`Hash.Value` is the typed wrapper for hash output:

```swift
let value: Hash.Value = .init(42)
let raw: Int = value.underlying
```

A `Copyable` type that already conforms to `Swift.Hashable` conforms with an empty extension under Swift <6.4 — and skips the conformance entirely under Swift 6.4+, because `Hash.Protocol` IS `Swift.Hashable` there:

```swift
struct UserID: Hashable, Hash.`Protocol` {
    let value: UInt64
}
// no body required — Swift.Hashable's hash(into:) satisfies the requirement
```

---

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-hash-primitives.git", branch: "main")
]
```

Add the umbrella product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Hash Primitives", package: "swift-hash-primitives")
    ]
)
```

For narrower surface, depend on `Hash Primitives Core` alone (typed wrapper + protocol, no stdlib bridge).

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the corresponding Linux / Windows toolchain).

---

## Architecture

Four library products plus a Test Support target:

| Product | Contents | When to import |
|---------|----------|----------------|
| `Hash Primitives` | Umbrella — re-exports Core + Standard Library Integration | Most consumers |
| `Hash Primitives Core` | `Hash` namespace, `Hash.Value`, `Hash.Protocol` | Embedded contexts, or when stdlib bridges are unwanted |
| `Hash Primitives Standard Library Integration` | `Hash.Protocol` refinements for standard-library types | Pulled in transitively by the umbrella |
| `Hash Primitives Test Support` | Re-export of upstream Test Support modules | Test target only |

---

## Stability

Pre-1.0. The 0.1.0 surface — `Hash.Value` typed wrapper, `Hash.Protocol`, the equals/hashCode refinement on `Equation.Protocol` — is committed to source-compatibility through the dual-mode bridge. The typed wrapper `Hash.Value` is independent of the SE-0499-driven protocol question and remains regardless of which compiler your consumer ships against. The eventual long-term shape, post-Swift-6.4-ecosystem-floor, is the protocol's typealias-to-stdlib reduction; the typed wrapper stays.

---

## Platform Support

| Platform         | CI  | Status       |
|------------------|-----|--------------|
| macOS 26         | Yes | Full support |
| Linux            | Yes | Full support |
| Windows          | Yes | Full support |
| iOS/tvOS/watchOS | —   | Supported    |
| Swift Embedded   | —   | Supported    |

---

## Related Packages

- [`swift-equation-primitives`](https://github.com/swift-primitives/swift-equation-primitives) — equality protocol that `Hash.Protocol` refines (encodes the equals/hashCode contract at the type level).
- [`swift-comparison-primitives`](https://github.com/swift-primitives/swift-comparison-primitives) — three-way comparison + `Comparison.Protocol` (also refines `Equation.Protocol`).
- [`swift-tagged-primitives`](https://github.com/swift-primitives/swift-tagged-primitives) — `Tagged<Hash, Int>` powers `Hash.Value`. `Tagged` itself conditionally conforms to `Hash.Protocol`.
- [`swift-property-primitives`](https://github.com/swift-primitives/swift-property-primitives) — fluent accessor namespaces.

---

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
