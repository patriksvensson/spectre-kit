
/// Represents a border.
public class BoxBorder {
    /// Gets the string representation of the specified border part.
    /// - Parameter part: The part to get the character representation for.
    /// - Returns: A character representation of the specified border part.
    public func get(part: BoxBorderPart) -> String {
        fatalError("Implement in a subclass")
    }
    
    /// Gets the safe border for this border or `nil` if none exist.
    public var safeBorder: BoxBorder? {
        get {
            nil
        }
    }
    
    /// Gets the safe border for a border.
    /// - Parameters:
    ///  - border: The border to get the safe border for.
    ///  - safe: Whether or not to return the safe border.
    /// - Returns: The safe border if one exist, otherwise the original border.
    public func getSafeBorder (safe: Bool) -> BoxBorder {
        if safe, let safeBorder {
            return safeBorder
        }
        return self
    }
    
    /// Gets an invisible border.
    static var none: BoxBorder { get { NoBoxBorder() } }
    
    /// Gets an ASCII border.
    static var ascii: BoxBorder  { get { AsciiBoxBorder() } }
    
    /// Gets a double border.
    static var double: BoxBorder  { get { DoubleBoxBorder() } }
    
    /// Gets a heavy border
    static var heavy: BoxBorder  { get { HeavyBoxBorder() } }
    
    /// Gets a rounded border
    static var rounded: BoxBorder  { get { RoundedBoxBorder() } }
    
    /// Gets a square border
    static var square: BoxBorder  { get { SquareBoxBorder() } }
}
