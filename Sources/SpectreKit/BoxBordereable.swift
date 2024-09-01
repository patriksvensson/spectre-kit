/// Represents something that has a box border.
public protocol BoxBordereable: AnyObject {
    /// Gets or sets the box.
    var border: BoxBorder { get set }
}

extension BoxBordereable where Self: AnyObject {
    public func setBorder(_ border: BoxBorder) -> Self {
        self.border = border
        return self
    }
}
