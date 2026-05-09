#if swift(<6.4)
    // Hash.Protocol+Swift.Hashable.swift
    // Bridge implementations for Swift.Hashable types.

    // MARK: - Integer Conformances

    extension Int: Hash.`Protocol` {}
    extension Int8: Hash.`Protocol` {}
    extension Int16: Hash.`Protocol` {}
    extension Int32: Hash.`Protocol` {}
    extension Int64: Hash.`Protocol` {}
    extension UInt: Hash.`Protocol` {}
    extension UInt8: Hash.`Protocol` {}
    extension UInt16: Hash.`Protocol` {}
    extension UInt32: Hash.`Protocol` {}
    extension UInt64: Hash.`Protocol` {}

    // MARK: - Other Standard Library Types

    extension Bool: Hash.`Protocol` {}
    extension String: Hash.`Protocol` {}
    extension Character: Hash.`Protocol` {}
    extension Double: Hash.`Protocol` {}
    extension Float: Hash.`Protocol` {}

#endif
