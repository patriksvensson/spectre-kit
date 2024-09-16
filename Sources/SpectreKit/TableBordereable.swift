/// Represents something that has a table border.
public protocol TableBordereable: Borderable, AnyObject {
    /// Gets or sets the box.
    var border: TableBorder { get set }
}

extension TableBordereable where Self: AnyObject {
    public func setBorder(_ border: TableBorder) -> Self {
        self.border = border
        return self
    }
}
