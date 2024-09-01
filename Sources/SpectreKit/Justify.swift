/// How text is justified
public enum Justify {
    /// Left justified
    case left
    /// Right justified
    case right
    /// Centered
    case center
}

public protocol Justifiable: AnyObject {
    var justification: Justify? { get set }
}

extension Justifiable where Self: AnyObject {
    /// Sets the justification
    public func justify(_ alignment: Justify?) -> Self {
        self.justification = alignment
        return self
    }

    /// Sets the object to be left justified.
    public func leftJustified() -> Self {
        self.justification = Justify.left
        return self
    }

    /// Sets the object to be centered.
    public func centered() -> Self {
        self.justification = Justify.center
        return self
    }

    /// Sets the object to be right justified.
    public func rightJustified() -> Self {
        self.justification = Justify.right
        return self
    }
}
