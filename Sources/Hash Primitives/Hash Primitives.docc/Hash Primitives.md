# ``Hash_Primitives``

@Metadata {
    @DisplayName("Hash Primitives")
    @TitleHeading("Swift Primitives")
}

A typed hash-output wrapper and a hashing protocol with `borrowing` parameters, so `~Copyable` types can be hashed without being copied.

## Overview

`Hash.Value` is a typed wrapper for hash output — `Tagged<Hash, Int>`, where the phantom tag is the `Hash` namespace itself. The wrapper prevents accidental misuse of arbitrary integers as hashes: at the type level, hashes are distinct from offsets, counts, and magic constants.

`Hash.Protocol` mirrors `Swift.Hashable` with a `borrowing` `hash(into:)` requirement, so move-only types can be hashed without being consumed. The `==` requirement is inherited from ``Equation_Primitives``'s `Equation.Protocol`, encoding Java's equals/hashCode contract at the type level: any type that can be hashed must also support equality.

```swift
import Hash_Primitives

struct Token: ~Copyable, Hash.`Protocol` {
    let id: Int

    static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        lhs.id == rhs.id
    }

    borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
```

The semantic invariant — equal values must produce equal hashes — remains your responsibility, but the type system stops you from declaring a hash without an equality.

## SE-0499 dual-mode

The package's reason for existing is the `borrowing` requirement that the stdlib's `Swift.Hashable` (until SE-0499 lands at the consumer's floor) does not provide. Under Swift <6.4, `Hash.Protocol` is a separate protocol fork. Under Swift 6.4+, the protocol *refines* `Swift.Hashable` (it does **not** alias it):

```swift
extension Hash {
    public protocol `Protocol`: Swift.Hashable, ~Copyable, ~Escapable {
        borrowing func hash(into hasher: inout Hasher)
        var hashValue: Hash.Value { get }   // typed; defaulted in an extension
    }
}
```

Refining — not aliasing — is deliberate (see the *Addendum 2026-06-01* in `swift-institute/Research/se-0499-implications-for-equation-hash-comparison-primitives.md`). A bare `typealias Protocol = Swift.Hashable` would erase `element.hashValue` to `Swift.Int`, breaking every generic consumer that passes it where `Hash.Value` is required. Refining keeps the typed `hashValue: Hash.Value` accessor while inheriting `Swift.Hashable`'s SE-0499 `borrowing` `hash(into:)`.

Because it refines rather than aliases, `Swift.Hashable` conformance alone does **not** make a stdlib type a `Hash.Protocol` conformer on 6.4 — the Standard-Library-Integration bridges are still required (see *Standard Library bridges* below). Conformances written today work on both compiler families: the borrowing signature matches what Swift 6.4's `Swift.Hashable` requires; on Swift 6.3 it matches the fork.

`Hash.Value` (the typed wrapper) is independent of the SE-0499 question — it ships in both compiler modes.

## Topics

### Namespace

- ``Hash``

### Typed hash output

- `Hash.Value` — alias for `Tagged<Hash, Int>`. The phantom tag prevents an arbitrary `Int` from being used where a hash is expected and vice versa.

### Hashing protocol

`Hash.Protocol` is the hashing protocol. Under Swift 6.4+ it *refines* `Swift.Hashable` (adding a typed `hashValue: Hash.Value` accessor); it is not a typealias. The fork branch (<6.4) declares `protocol \`Protocol\`: Equation.\`Protocol\`, ~Copyable, ~Escapable` with a `borrowing func hash(into hasher: inout Hasher)` requirement, plus a default `hashValue: Hash.Value` accessor.

### Standard Library bridges

Stdlib `Hashable` types are re-conformed to `Hash.Protocol` via the `Hash Primitives Standard Library Integration` target on **both** compiler families. Under Swift <6.4 the bridges supply full fork conformances (custom `hash(into:)` bodies). Under Swift 6.4+ they supply an empty refining conformance (`extension Int: Hash.Protocol {}`, etc.) — the stdlib `Swift.Hashable` conformance witnesses `hash(into:)` and `hashValue: Hash.Value` is defaulted, but the refinement still has to be stated explicitly because refining (not aliasing) means `Swift.Hashable` conformance alone is insufficient. Types that are not stdlib-`Hashable`/`Equatable` (`Span`, `KeyValuePairs`, partial ranges, reversed collections, buffer pointers) are handled case by case; some remain gated to <6.4 pending an `Equation.Protocol` (Equatable) 6.4 bridge in ``Equation_Primitives``.
