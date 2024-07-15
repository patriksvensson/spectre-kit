/// Represents a column
public protocol Column: Paddable, Alignable {
    /// Gets or sets a value indicating whether
    /// or not wrapping should be prevented.
    var noWrap: Bool { get set }
    
    /// Gets or sets the width of the column.
    var width: Int? { get set }
}
