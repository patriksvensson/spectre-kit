// Note: in C# the BoxBorder is modeled with abstract classes
// that do not exist in Swift, a companion "IHasBorder" which looks
// odd here, so I renamed to Borderable.

/// The protocol for borders
public protocol Borderable {
    /// Gets or sets a value indicating whether or not to use
    /// a "safe" border on legacy consoles that might not be able
    /// to render non-ASCII characters.
    var useSafeBorder: Bool { get set }

    var borderStyle: Style? { get set }
}

extension Borderable {
    public var safeBorder: BoxBorder? { nil }
}
