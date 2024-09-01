/// Represents something that is expandable.
public protocol Expandable: AnyObject {
    /// Gets or sets the whether or not the object
    /// should expand to the available space (greedy).
    var expand: Bool { get set }
}

extension Expandable where Self: AnyObject {
    /// Tells the specified object to not expand to the available area
    /// but take as little space as possible.
    public func collapse() -> Self {
        self.expand = false
        return self
    }

    /// Tells the specified object to expand to the available area.
    public func expand() -> Self {
        self.expand = true
        return self
    }
}
