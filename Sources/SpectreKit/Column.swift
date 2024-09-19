/// Represents a column
public protocol Column: Paddable, Alignable {
    /// Gets or sets a value indicating whether
    /// or not wrapping should be prevented.
    var noWrap: Bool { get set }

    /// Gets or sets the width of the column.
    var width: Int? { get set }
}

extension Column {
    @discardableResult
    public func width(_ width: Int?) -> Self {
        self.width = width
        return self
    }

    @discardableResult
    public func noWrap(_ noWrap: Bool = true) -> Self {
        self.noWrap = noWrap
        return self
    }
}
