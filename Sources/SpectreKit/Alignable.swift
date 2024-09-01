/// Represents something that is alignable.
public protocol Alignable: AnyObject {
    /// Gets or sets the alignment.
    var alignment: Justify? { get set }
}

extension Alignable where Self: AnyObject {
    /// Sets the justification
    public func alinment(_ alignment: Justify?) -> Self {
        self.alignment = alignment
        return self
    }

    /// Sets the object to be left justified.
    public func leftAligned() -> Self {
        self.alignment = Justify.left
        return self
    }

    /// Sets the object to be centered.
    public func centered() -> Self {
        self.alignment = Justify.center
        return self
    }

    /// Sets the object to be right justified.
    public func rightAligned() -> Self {
        self.alignment = Justify.right
        return self
    }
}
