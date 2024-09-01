/// Represents text overflow.
public enum Overflow {
    /// Represents text overflow.
    case fold

    /// Truncates the text at the end of the line.
    case crop

    /// Truncates the text at the end of the line and
    /// also inserts an ellipsis character.
    case ellipsis
}

/// Represents something that can overflow.
public protocol Overflowable: AnyObject {
    /// Gets or sets the text overflow strategy.
    var overflow: Overflow? { get set }
}

extension Overflowable where Self: AnyObject {
    /// Folds any overflowing text.
    public func fold() -> Self {
        return overflow(Overflow.fold)
    }

    /// Crops any overflowing text.
    public func crop() -> Self {
        return overflow(Overflow.crop)
    }

    /// Crops any overflowing text and adds an ellipsis to the end.
    public func ellipsis() -> Self {
        return overflow(Overflow.ellipsis)
    }

    /// Sets the overflow strategy.
    public func overflow(_ overflow: Overflow) -> Self {
        self.overflow = overflow
        return self
    }
}
