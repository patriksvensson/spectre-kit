/// Represents a border.
public class TableBorder {
    /// Gets a value indicating whether or not the border is visible.
    public var visible: Bool = true

    /// Gets the string representation of a specified table border part.
    /// - Parameter part: The part to get the character representation for.
    /// - Returns: A character representation of the specified border part.
    public func get(part: TableBorderPart) -> String {
        fatalError("Implement in a subclass")
    }

    /// Gets the safe border for this border or `nil` if none exist.
    public var safeBorder: TableBorder? {
        nil
    }

    /// Gets a value indicating whether the border supports row separators or not.
    public var supportsRowSeparator: Bool = true

    /// Gets a whole column row for the specific column row part.
    /// - Parameters:
    ///  - part: The column row part.
    ///  - widths: The column widths.
    ///  - columns: The columns.
    /// - Returns: A string representing the column row.
    public func getColumnRow(part: TablePart, widths: [Int], columns: [Column]) -> String {
        let (left, center, separator, right) = getTableParts(part: part)

        var builder = ""
        builder.append(left)

        for (columnIndex, _, isLastColumn, columnWidth) in widths.makeSequenceIterator() {
            let padding = columns[columnIndex].padding
            let centerWidth =
                padding.getSafeLeftPadding() + columnWidth + padding.getSafeRightPadding()
            builder += String(repeating: center, count: centerWidth)

            if !isLastColumn {
                builder += separator
            }
        }

        builder.append(right)
        return builder
    }

    /// Gets the table parts used to render a specific table row.
    /// - Parameter part: The table part.
    /// - Returns: The table parts used to render the specific table row.
    func getTableParts(part: TablePart) -> (
        left: String, center: String, separator: String, right: String
    ) {
        switch part {
        // Top part
        case .top:
            (
                get(part: .headerTopLeft), get(part: .headerTop),
                get(part: .headerTopSeparator), get(part: .headerTopRight)
            )

        // Separator between header and cells
        case .headerSeparator:
            (
                get(part: .headerBottomLeft), get(part: .headerBottom),
                get(part: .headerBottomSeparator), get(part: .headerBottomRight)
            )

        // Separator between header and cells
        case .rowSeparator:
            (
                get(part: .rowLeft), get(part: .rowCenter),
                get(part: .rowSeparator), get(part: .rowRight)
            )

        // Separator between footer and cells
        case .footerSeparator:
            (
                get(part: .footerTopLeft), get(part: .footerTop),
                get(part: .footerTopSeparator), get(part: .footerTopRight)
            )

        // Bottom part
        case .bottom:
            (
                get(part: .footerBottomLeft), get(part: .footerBottom),
                get(part: .footerBottomSeparator), get(part: .footerBottomRight)
            )

        }
    }

    /// Gets the safe border for a border.
    /// - Parameters:
    ///  - border: The border to get the safe border for.
    ///  - safe: Whether or not to return the safe border.
    /// - Returns: The safe border if one exist, otherwise the original border.
    public func getSafeBorder(safe: Bool) -> TableBorder {
        if safe, let safeBorder {
            return safeBorder
        }
        return self
    }

    /// Gets an invisible border.
    public static var none: TableBorder { NoTableBorder() }

    /// Gets an ASCII border.
    public static var ascii: TableBorder { AsciiTableBorder() }

    /// Gets an ASCII border.
    public static var ascii2: TableBorder { Ascii2TableBorder() }

    /// Gets an ASCII border.
    public static var asciiDoubleHead: TableBorder { AsciiDoubleHeadTableBorder() }

    /// Gets a double border.
    public static var double: TableBorder { DoubleTableBorder() }

    /// Gets a heavy border
    public static var heavy: TableBorder { HeavyTableBorder() }

    /// Gets a rounded border
    public static var rounded: TableBorder { RoundedTableBorder() }

    /// Gets a square border
    public static var square: TableBorder { SquareTableBorder() }

    /// Gets a square border
    public static var minimal: TableBorder { MinimalTableBorder() }

    /// Gets a minimal border with a heavy head.
    public static var minimalHeavyHead: TableBorder { MinimalHeavyHeadTableBorder() }

    /// Gets a minimal border with a double header border.
    public static var minimalDoubleHead: TableBorder { MinimalDoubleHeadTableBorder() }

    /// Gets a simple border.
    public static var simple: TableBorder { SimpleTableBorder() }

    /// Gets a simple border with heavy lines.
    public static var simpleHeavy: TableBorder { SimpleHeavyTableBorder() }

    /// Gets horizontal border
    public static var horizontal: TableBorder { HorizontalTableBorder() }

    /// Gets a border with a heavy edge
    public static var heavyEdge: TableBorder { HeavyEdgeTableBorder() }

    /// Gets a border with a heavy header.
    public static var heavyHead: TableBorder { HeavyHeadTableBorder() }

    /// Gets a border with a double edge.
    public static var doubleEdge: TableBorder { DoubleEdgeTableBorder() }

    /// Gets a markdown border.
    public static var markdown: TableBorder { MarkdownTableBorder() }
}
