/// How text is justified
public enum Justify {
    /// Left justified
    case left
    /// Right justified
    case right
    /// Centered
    case center
}

public protocol Justifiable {
    var justification: Justify? { get set }
}
