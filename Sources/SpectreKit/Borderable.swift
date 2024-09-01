// Note: in C# the BoxBorder is modeled with abstract classes
// that do not exist in Swift, a companion "IHasBorder" which looks
// odd here, so I renamed to Borderable.

/// The protocol for borders
public protocol Borderable: AnyObject {
    /// Gets or sets a value indicating whether or not to use
    /// a "safe" border on legacy consoles that might not be able
    /// to render non-ASCII characters.
    var useSafeBorder: Bool { get set }

    /// Gets or sets the box style.
    var borderStyle: Style? { get set }
}

extension Borderable {
    public var safeBorder: BoxBorder? { nil }
}

extension Borderable where Self: AnyObject {
    public func setBorderStyle(_ style: Style?) -> Self {
        self.borderStyle = style
        return self
    }

    public func useSafeBorder() -> Self {
        self.useSafeBorder = true
        return self
    }

    public func noSafeBorder() -> Self {
        self.useSafeBorder = false
        return self
    }
}
