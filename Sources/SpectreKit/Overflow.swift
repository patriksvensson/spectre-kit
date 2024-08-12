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

///Represents something that can overflow.
public protocol Overflowable {
    /// Gets or sets the text overflow strategy.
    var overflow: Overflow? { get set }
}
