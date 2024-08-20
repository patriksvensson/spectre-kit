/// Represents a Markdown border.
public class MarkdownTableBorder: TableBorder {

    public override var supportsRowSeparator: Bool {
        get {
            false
        }
        set {}
    }

    public override func get(part: TableBorderPart) -> String {
        switch part {
        case .headerTopLeft: " "
        case .headerTop: " "
        case .headerTopSeparator: " "
        case .headerTopRight: " "
        case .headerLeft: "|"
        case .headerSeparator: "|"
        case .headerRight: "|"
        case .headerBottomLeft: "|"
        case .headerBottom: "-"
        case .headerBottomSeparator: "|"
        case .headerBottomRight: "|"
        case .cellLeft: "|"
        case .cellSeparator: "|"
        case .cellRight: "|"
        case .footerTopLeft: " "
        case .footerTop: " "
        case .footerTopSeparator: " "
        case .footerTopRight: " "
        case .footerBottomLeft: " "
        case .footerBottom: " "
        case .footerBottomSeparator: " "
        case .footerBottomRight: " "
        case .rowLeft: " "
        case .rowCenter: " "
        case .rowSeparator: " "
        case .rowRight: " "
        }
    }
    //
    //    public override string GetColumnRow(TablePart part, IReadOnlyList<int> widths, IReadOnlyList<IColumn> columns)
    //        if (part == TablePart.FooterSeparator)
    //            return string.Empty;
    //        }
    //        if (part != TablePart.HeaderSeparator)
    //            return base.GetColumnRow(part, widths, columns);
    //        }
    //        var (left, center, separator, right) = GetTableParts(part);
    //        var builder = new StringBuilder();
    //        builder.Append(left);
    //        foreach (var (columnIndex, _, lastColumn, columnWidth) in widths.Enumerate())
    //            var padding = columns[columnIndex].Padding;
    //            if (padding != null && padding.Value.Left > 0)
    //            {
    //                // Left padding
    //                builder.Append(" ".Repeat(padding.Value.Left));
    //            }
    //            var justification = columns[columnIndex].Alignment;
    //            if (justification == null)
    //            {
    //                // No alignment
    //                builder.Append(center.Repeat(columnWidth));
    //            }
    //            else if (justification.Value == Justify.Left)
    //            {
    //                // Left
    //                builder.Append(':');
    //                builder.Append(center.Repeat(columnWidth - 1));
    //            }
    //            else if (justification.Value == Justify.Center)
    //            {
    //                // Centered
    //                builder.Append(':');
    //                builder.Append(center.Repeat(columnWidth - 2));
    //                builder.Append(':');
    //            }
    //            else if (justification.Value == Justify.Right)
    //            {
    //                // Right
    //                builder.Append(center.Repeat(columnWidth - 1));
    //                builder.Append(':');
    //            }
    //            // Right padding
    //            if (padding != null && padding.Value.Right > 0)
    //            {
    //                builder.Append(" ".Repeat(padding.Value.Right));
    //            }
    //            if (!lastColumn)
    //            {
    //                builder.Append(separator);
    //            }
    //        }
    //        builder.Append(right);
    //        return builder.ToString();
    //    }
}
