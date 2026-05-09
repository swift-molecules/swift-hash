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

The package's reason for existing is the `borrowing` requirement that the stdlib's `Swift.Hashable` (until SE-0499 lands at the consumer's floor) does not provide. Under Swift <6.4, `Hash.Protocol` is a separate protocol fork. Under Swift 6.4+, the protocol is a typealias to `Swift.Hashable`:

```swift
#if swift(>=6.4)
    extension Hash {
        public typealias `Protocol` = Swift.Hashable
    }
#else
    extension Hash {
        public protocol `Protocol`: Equation.`Protocol`, ~Copyable {
            borrowing func hash(into hasher: inout Hasher)
        }
    }
#endif
```

Conformances written today work on both compiler families. The borrowing signature matches what Swift 6.4's `Swift.Hashable` requires; on Swift 6.3 it matches the fork.

`Hash.Value` (the typed wrapper) is independent of the SE-0499 question — it ships in both compiler modes.

## Topics

### Namespace

- ``Hash``

### Typed hash output

- `Hash.Value` — alias for `Tagged<Hash, Int>`. The phantom tag prevents an arbitrary `Int` from being used where a hash is expected and vice versa.

### Hashing protocol

`Hash.Protocol` is the hashing protocol; under Swift 6.4+ it is a typealias to `Swift.Hashable`. The fork branch declares `protocol \`Protocol\`: Equation.\`Protocol\`, ~Copyable` with a `borrowing func hash(into hasher: inout Hasher)` requirement, plus a default `hashValue: Hash.Value` accessor.

### Standard Library bridges

Under Swift <6.4, stdlib `Hashable` types are re-conformed to `Hash.Protocol` via the `Hash Primitives Standard Library Integration` target. Under Swift 6.4+, those bridges become no-ops because `Hash.Protocol` IS `Swift.Hashable` and stdlib conformances already satisfy it.
