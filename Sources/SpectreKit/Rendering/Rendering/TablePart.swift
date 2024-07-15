/// Represents different parts of a table.
public enum TablePart {
    /// The top of a table.
    case top

    /// The separator between the header and the cells.
    case headerSeparator

    /// The separator between the rows.
    case rowSeparator

    /// The separator between the footer and the cells.
    case footerSeparator

    /// The bottom of a table.
    case bottom
}
