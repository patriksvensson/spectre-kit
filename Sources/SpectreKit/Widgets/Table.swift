// -----------------------------------------------------------------------------
// Table

public class Table: Renderable, TableBordereable, Expandable, Alignable {
    var columns: [TableColumn]
    var rows: [TableRow]

    public var border: TableBorder
    public var useSafeBorder: Bool
    public var borderStyle: Style?
    public var expand: Bool
    public var alignment: Justify?

    public var showHeaders: Bool
    public var showFooters: Bool
    public var showRowSeparators: Bool
    public var width: Int?

    public var title: TableTitle?
    public var caption: TableTitle?

    // Whether or not the most right cell should be padded.
    // This is almost always the case, unless we're rendering
    // a grid without explicit padding in the last cell.
    var padRightCell: Bool = true
    var isGrid: Bool = false

    public init() {
        self.columns = []
        self.rows = []
        self.border = TableBorder.square
        self.useSafeBorder = true
        self.expand = false
        self.showHeaders = true
        self.showFooters = true
        self.showRowSeparators = false
    }

    @discardableResult
    public func addColumn(_ column: TableColumn) -> Self {
        precondition(rows.count == 0, "Cannot add new columns to table with existing rows.")
        self.columns.append(column)
        return self
    }

    @discardableResult
    public func addRow(_ columns: [any Renderable]) -> Self {
        self.rows.append(TableRow(columns))
        return self
    }

    @discardableResult
    public func addRow(_ columns: any Renderable...) -> Self {
        self.rows.append(TableRow(columns))
        return self
    }

    public func measure(options: RenderOptions, maxWidth: Int) -> Measurement {
        let measurer = TableMeasurer(table: self, options: options)

        // Calculate the total cell width
        let totalCellWidth = measurer.calculateTotalCellWidth(maxWidth)

        // Calculate the minimum and maximum table width
        let measurements = self.columns.map { measurer.measureColumn($0, maxWidth: totalCellWidth) }
        let minTableWidth =
            measurements.reduce(0, { a, b in a + b.min }) + measurer.getNonColumnWidth()
        let maxTableWidth =
            self.width
            ?? (measurements.reduce(0, { a, b in a + b.max }) + measurer.getNonColumnWidth())

        return Measurement(min: minTableWidth, max: maxTableWidth)
    }

    public func render(options: RenderOptions, maxWidth: Int) -> [Segment] {
        // Calculate the different widths we need
        let measurer = TableMeasurer(table: self, options: options)
        let totalCellWidth = measurer.calculateTotalCellWidth(maxWidth)
        let columnWidths = measurer.calculateColumnWidths(maxWidth: totalCellWidth)
        let tableWidth = columnWidths.sum() + measurer.getNonColumnWidth()

        let renderer = TableRenderer.init(table: self, options: options)
        return renderer.render(
            tableWidth: tableWidth, maxWidth: maxWidth, columnWidths: columnWidths)
    }
}

extension Table {
    @discardableResult
    public func addColumn(_ markup: String, fn: ((TableColumn) -> Void)? = nil) -> Self {
        let column = TableColumn(Markup(markup))
        if let fn = fn {
            fn(column)
        }

        self.addColumn(column)
        return self
    }

    @discardableResult
    public func addColumns(_ columns: String...) -> Self {
        for column in columns {
            self.addColumn(column)
        }
        return self
    }

    @discardableResult
    public func addRow(_ columns: String...) -> Self {
        self.addRow(columns.map { Markup($0) })
        return self
    }

    @discardableResult
    public func setTitle(_ title: TableTitle) -> Self {
        self.title = title
        return self
    }

    @discardableResult
    public func setTitle(_ title: String) -> Self {
        self.title = TableTitle(title)
        return self
    }

    @discardableResult
    public func setCaption(_ caption: TableTitle) -> Self {
        self.caption = caption
        return self
    }

    @discardableResult
    public func setCaption(_ caption: String) -> Self {
        self.caption = TableTitle(caption)
        return self
    }

    @discardableResult
    public func showRowSeparators(_ show: Bool = true) -> Self {
        self.showRowSeparators = show
        return self
    }

    @discardableResult
    public func hideRowSeparators() -> Self {
        self.showRowSeparators = false
        return self
    }

    @discardableResult
    public func showFooters(_ show: Bool = true) -> Self {
        self.showFooters = show
        return self
    }

    @discardableResult
    public func hideFooters() -> Self {
        self.showFooters = false
        return self
    }

    @discardableResult
    public func showHeaders(_ show: Bool = true) -> Self {
        self.showHeaders = show
        return self
    }

    @discardableResult
    public func hideHeaders() -> Self {
        self.showHeaders = false
        return self
    }

    @discardableResult
    public func width(_ width: Int) -> Self {
        self.width = width
        return self
    }
}

// -----------------------------------------------------------------------------
// TableColumn

public class TableColumn: Column, Equatable {
    public var header: Renderable
    public var footer: Renderable?
    public var noWrap: Bool
    public var width: Int?
    public var padding: Padding?
    public var alignment: Justify?

    public convenience init(_ header: String) {
        self.init(Markup(header))
    }

    public init(_ header: Renderable) {
        self.header = header
        self.width = nil
        self.padding = Padding(left: 1, top: 0, right: 1, bottom: 0)
        self.noWrap = false
        self.alignment = nil
    }

    public static func == (lhs: TableColumn, rhs: TableColumn) -> Bool {
        return lhs === rhs
    }
}

extension TableColumn {
    public func setFooter(_ footer: String) -> Self {
        self.footer = Markup(footer)
        return self
    }
}

// -----------------------------------------------------------------------------
// TableRow

public class TableRow {
    public var items: [any Renderable]
    public var kind: TableRowKind

    public var isHeader: Bool {
        switch kind {
        case .header: return true
        default:
            return false
        }
    }

    public var isFooter: Bool {
        switch kind {
        case .footer: return true
        default:
            return false
        }
    }

    public convenience init(_ items: [any Renderable]) {
        self.init(items, TableRowKind.row)
    }

    private init(_ items: [any Renderable], _ kind: TableRowKind) {
        self.items = items
        self.kind = kind
    }

    public static func header(_ items: [any Renderable]) -> TableRow {
        return TableRow(items, TableRowKind.header)
    }

    public static func footer(_ items: [any Renderable]) -> TableRow {
        return TableRow(items, TableRowKind.footer)
    }

    public func append(_ item: Renderable) {
        self.items.append(item)
    }
}

// -----------------------------------------------------------------------------
// TableRowKind

public enum TableRowKind {
    case header
    case row
    case footer
}

// -----------------------------------------------------------------------------
// TableTitle

public class TableTitle {
    public var text: String
    public var style: Style?

    public init(_ text: String, style: Style? = nil) {
        self.text = text
        self.style = style
    }

    public func setStyle(_ style: Style?) -> Self {
        self.style = style
        return self
    }

    public func setStyle(_ style: String) throws -> Self {
        self.style = try Style.parse(style)
        return self
    }
}

// -----------------------------------------------------------------------------
// TableMeasurer

class TableMeasurer {
    private let edgeCount: Int = 2

    private var table: Table
    private var options: RenderOptions
    private var expand: Bool { self.table.width != nil || self.table.expand }

    init(table: Table, options: RenderOptions) {
        self.table = table
        self.options = options
    }

    func calculateTotalCellWidth(_ maxWidth: Int) -> Int {
        var totalCellWidth = maxWidth
        if let explicitWidth = table.width {
            totalCellWidth = min(explicitWidth, maxWidth)
        }
        return totalCellWidth - getNonColumnWidth()
    }

    func getNonColumnWidth() -> Int {
        let hideBorder = !self.table.border.visible
        let separators = hideBorder ? 0 : self.table.columns.count - 1
        let edges = hideBorder ? 0 : self.edgeCount
        var padding = self.table.columns.map { $0.padding?.getWidth() ?? 0 }.sum()

        if !self.table.padRightCell {
            padding -= (self.table.columns.last?.padding).getSafeRightPadding()
        }

        return separators + edges + padding
    }

    func calculateColumnWidths(maxWidth: Int) -> [Int] {
        let widthRanges = self.table.columns.map { measureColumn($0, maxWidth: maxWidth) }
        var widths = widthRanges.map { $0.max }

        var tableWidth = widths.sum()
        if tableWidth > maxWidth {
            let wrappable = self.table.columns.map { !$0.noWrap }
            widths = collapseWidths(widths: widths, wrappable: wrappable, maxWidth: maxWidth)
            tableWidth = widths.sum()

            // last resort, reduce columns evenly
            if tableWidth > maxWidth {
                let excessWidth = tableWidth - maxWidth
                widths = Ratio.reduce(
                    total: excessWidth, ratios: widths.map({ _ in 1 }), maximums: widths,
                    values: widths)
                tableWidth = widths.sum()
            }
        }

        if tableWidth < maxWidth && self.expand {
            let padWidths = Ratio.distribute(total: maxWidth - tableWidth, ratios: widths)
            widths = widths.zip(padWidths).map({ $0.0 + $0.1 })
        }

        return widths
    }

    func measureColumn(_ column: TableColumn, maxWidth: Int) -> Measurement {
        if let width = column.width {
            return Measurement(min: width, max: width)
        }

        guard let columnIndex = self.table.columns.firstIndex(of: column) else {
            fatalError("column was not part of table")
        }

        let rows = self.table.rows.map { $0.items[columnIndex] }
        var minWidths: [Int] = []
        var maxWidths: [Int] = []

        let headerMeasure = column.header.measure(options: options, maxWidth: maxWidth)
        let footerMeasure =
            column.footer?.measure(options: options, maxWidth: maxWidth) ?? headerMeasure
        minWidths.append(min(headerMeasure.min, footerMeasure.min))
        maxWidths.append(max(headerMeasure.max, footerMeasure.max))

        for row in rows {
            let rowMeasure = row.measure(options: options, maxWidth: maxWidth)
            minWidths.append(rowMeasure.min)
            maxWidths.append(rowMeasure.max)
        }

        let padding = column.padding?.getWidth() ?? 0

        return Measurement(
            min: minWidths.count > 0 ? (minWidths.max() ?? 0) : padding,
            max: maxWidths.count > 0 ? (maxWidths.max() ?? 0) : maxWidth
        )
    }

    // Reduce widths so that the total is less or equal to the max width.
    // Ported from Rich by Will McGugan, licensed under MIT.
    // https://github.com/willmcgugan/rich/blob/527475837ebbfc427530b3ee0d4d0741d2d0fc6d/rich/table.py#L442
    func collapseWidths(widths: [Int], wrappable: [Bool], maxWidth: Int) -> [Int] {
        var widths = widths
        var totalWidth = widths.sum()
        var excessWidth = totalWidth - maxWidth

        if wrappable.any({ $0 == true }) {
            while totalWidth != 0 && excessWidth > 0 {
                let maxColumn =
                    widths
                    .zip(
                        wrappable,
                        { (width: Int, allowWrap: Bool) -> ((width: Int, allowWrap: Bool)) in
                            (width, allowWrap)
                        }
                    )
                    .filter { $0.allowWrap }
                    .max { a, b in a.width < b.width }?.width ?? 0

                let secondMaxColumn =
                    widths.zip(wrappable) { width, allowWrap in
                        allowWrap && width != maxColumn ? width : 1
                    }.max() ?? 0
                let columnDifference = maxColumn - secondMaxColumn

                let ratios = widths.zip(wrappable) { width, allowWrap in
                    allowWrap && width == maxColumn ? 1 : 0
                }
                if !ratios.any({ $0 != 0 }) || columnDifference == 0 {
                    break
                }

                let maxReduce = widths.map { _ in min(excessWidth, columnDifference) }
                widths = Ratio.reduce(
                    total: excessWidth, ratios: ratios, maximums: maxReduce, values: widths)

                totalWidth = widths.sum()
                excessWidth = totalWidth - maxWidth
            }
        }

        return widths
    }
}

// -----------------------------------------------------------------------------
// TableRenderer

class TableRenderer {
    private let defaultTitleColor: Style = Style(foreground: Color.number(7))  // Silver

    private var table: Table
    private var options: RenderOptions
    private var rows: [TableRow]
    private var expand: Bool { self.table.width != nil && self.table.expand }

    private var showBorder: Bool
    private var hideBorder: Bool { !showBorder }
    private var hasRows: Bool
    private var hasFooters: Bool
    private var borderStyle: Style
    private var border: TableBorder

    init(table: Table, options: RenderOptions) {
        self.table = table
        self.options = options
        self.rows = TableRenderer.getRenderableRows(self.table)
        self.showBorder = self.table.border.visible
        self.hasRows = self.rows.any({ !$0.isHeader && !$0.isFooter })
        self.hasFooters = self.rows.any({ $0.isFooter })
        self.borderStyle = self.table.borderStyle ?? Style.plain
        self.border = self.table.border.getSafeBorder(
            safe: !options.unicode && self.table.useSafeBorder)
    }

    func render(tableWidth: Int, maxWidth: Int, columnWidths: [Int]) -> [Segment] {
        // Can't render the table?
        if tableWidth <= 0 || tableWidth > maxWidth || columnWidths.any({ $0 < 0 }) {
            return [Segment.text(content: "-", style: self.borderStyle)]
        }

        var result: [Segment] = []
        result.append(
            contentsOf: renderAnnotation(
                self.table.title, tableWidth: tableWidth, maxWidth: maxWidth,
                defaultStyle: self.defaultTitleColor))

        // Iterate all rows
        for (index, isFirstRow, isLastRow, row) in self.rows.makeSequenceIterator() {
            var cellHeight = 1

            // Get the list of cells for the row and calculate the cell height
            var cells = [[SegmentLine]]()
            for (columnIndex, _, _, (columnWidth, cell)) in columnWidths.zip(row.items)
                .makeSequenceIterator()
            {
                var renderedCell = cell.render(options: options, maxWidth: columnWidth)
                Aligner.align(
                    &renderedCell, alignment: self.table.columns[columnIndex].alignment,
                    maxWidth: columnWidth)

                let lines = Segment.splitLines(segments: renderedCell)
                cellHeight = max(cellHeight, lines.count)
                cells.append(lines)
            }

            // Show top of header?
            if isFirstRow && self.showBorder {
                let separator = Aligner.align(
                    self.border.getColumnRow(
                        part: TablePart.top, widths: columnWidths, columns: self.table.columns),
                    alignment: self.table.alignment, maxWidth: maxWidth)
                result.append(Segment.text(content: separator, style: self.table.borderStyle))
                result.append(Segment.lineBreak)
            }

            // Show footer separator?
            if self.table.showFooters && isLastRow && self.showBorder && self.hasFooters {
                let textBorder = self.table.border.getColumnRow(
                    part: TablePart.footerSeparator, widths: columnWidths,
                    columns: self.table.columns)
                if !textBorder.isEmpty {
                    let separator = Aligner.align(
                        textBorder, alignment: self.table.alignment, maxWidth: maxWidth)
                    result.append(Segment.text(content: separator, style: self.table.borderStyle))
                    result.append(Segment.lineBreak)
                }
            }

            // Make cells the same shape
            cells = TableRenderer.makeSameHeight(cells, height: cellHeight)

            // Iterate through each cell row
            for cellRowIndex in 0..<cellHeight {
                var rowResult: [Segment] = []

                for (cellIndex, isFirstCell, isLastCell, cell) in cells.makeSequenceIterator() {
                    // Show left column edge
                    if isFirstCell && self.showBorder {
                        let part =
                            isFirstRow && self.table.showHeaders
                            ? TableBorderPart.headerLeft : TableBorderPart.cellLeft
                        rowResult.append(
                            Segment.text(
                                content: self.border.get(part: part), style: self.borderStyle))
                    }

                    // Pad column on left side.
                    if self.showBorder || self.table.isGrid {
                        let leftPadding = self.table.columns[cellIndex].padding.getSafeLeftPadding()
                        if leftPadding > 0 {
                            rowResult.append(
                                Segment.whitespace(
                                    content: String(repeating: " ", count: leftPadding)))
                        }
                    }

                    // Add content
                    rowResult.append(contentsOf: cell[cellRowIndex].segments)

                    // Pad cell content right
                    let length = cell[cellRowIndex].cellCount
                    if length < columnWidths[cellIndex] {
                        rowResult.append(
                            Segment.whitespace(
                                content: String(
                                    repeating: " ", count: columnWidths[cellIndex] - length)
                            ))
                    }

                    // Pad column on the right side
                    if self.showBorder || (self.hideBorder && !isLastCell)
                        || (self.hideBorder && isLastCell && self.table.isGrid
                            && self.table.padRightCell)
                    {
                        let rightPadding = self.table.columns[cellIndex].padding
                            .getSafeRightPadding()
                        if rightPadding > 0 {
                            rowResult.append(
                                Segment.whitespace(
                                    content: String(repeating: " ", count: rightPadding)))
                        }
                    }

                    if isLastCell && self.showBorder {
                        // Add right column edge
                        let part =
                            isFirstRow && self.table.showHeaders
                            ? TableBorderPart.headerRight : TableBorderPart.cellRight
                        rowResult.append(
                            Segment.text(
                                content: self.border.get(part: part), style: self.borderStyle))
                    } else {
                        // Add column separator
                        let part =
                            isFirstRow && self.table.showHeaders
                            ? TableBorderPart.headerSeparator : TableBorderPart.cellSeparator
                        rowResult.append(
                            Segment.text(
                                content: self.border.get(part: part), style: self.borderStyle))
                    }
                }

                // Align the row result
                Aligner.align(&rowResult, alignment: self.table.alignment, maxWidth: maxWidth)

                // Is the row larger than the allowed max width?
                if rowResult.cellCount > maxWidth {
                    result.append(contentsOf: Segment.truncate(rowResult, maxWidth: maxWidth))
                } else {
                    result.append(contentsOf: rowResult)
                }

                result.append(Segment.lineBreak)
            }

            // Show header separator?
            if isFirstRow && self.showBorder && self.table.showHeaders && self.hasRows {
                let separator = Aligner.align(
                    self.border.getColumnRow(
                        part: TablePart.headerSeparator, widths: columnWidths,
                        columns: self.table.columns),
                    alignment: self.table.alignment,
                    maxWidth: maxWidth)
                result.append(Segment.text(content: separator, style: self.borderStyle))
                result.append(Segment.lineBreak)
            }

            // Show row separator, if headers are hidden show separator after the first row
            if self.border.supportsRowSeparator && self.table.showRowSeparators
                && (!isFirstRow || (isFirstRow && !self.table.showHeaders)) && !isLastRow
            {
                let hasVisibleFooters = self.table.showFooters && self.hasFooters
                let isNextLastLine = index == self.rows.count - 2

                let isRenderingFooter = hasVisibleFooters && isNextLastLine
                if !isRenderingFooter {
                    let separator = Aligner.align(
                        self.border.getColumnRow(
                            part: TablePart.rowSeparator, widths: columnWidths,
                            columns: self.table.columns),
                        alignment: self.table.alignment,
                        maxWidth: maxWidth)
                    result.append(Segment.text(content: separator, style: self.borderStyle))
                    result.append(Segment.lineBreak)
                }
            }

            // Show bottom of footer?
            if isLastRow && self.showBorder {
                let separator = Aligner.align(
                    self.border.getColumnRow(
                        part: TablePart.bottom, widths: columnWidths,
                        columns: self.table.columns),
                    alignment: self.table.alignment,
                    maxWidth: maxWidth)
                result.append(Segment.text(content: separator, style: self.borderStyle))
                result.append(Segment.lineBreak)
            }
        }

        result.append(
            contentsOf: renderAnnotation(
                self.table.caption, tableWidth: tableWidth, maxWidth: maxWidth,
                defaultStyle: self.defaultTitleColor))

        return result
    }

    private static func makeSameHeight(_ cells: [[SegmentLine]], height: Int) -> [[SegmentLine]] {
        var cells = cells
        for (index, var _) in cells.enumerated() {
            if cells[index].count < height {
                while cells[index].count != height {
                    cells[index].append(SegmentLine())
                }
            }
        }
        return cells
    }

    private func renderAnnotation(
        _ header: TableTitle?, tableWidth: Int, maxWidth: Int, defaultStyle: Style
    ) -> [Segment] {
        guard let header = header else {
            return []
        }

        let paragraph = Markup(header.text, style: header.style ?? defaultStyle)
            .justify(Justify.center)
            .overflow(Overflow.ellipsis)

        var segments: [Segment] = paragraph.render(options: self.options, maxWidth: tableWidth)
        Aligner.align(&segments, alignment: self.table.alignment, maxWidth: maxWidth)
        segments.append(Segment.lineBreak)

        return segments
    }

    // Gets all renderable rows in the table
    private static func getRenderableRows(_ table: Table) -> [TableRow] {
        var rows: [TableRow] = []
        if table.showHeaders {
            rows.append(TableRow.header(table.columns.map({ $0.header })))
        }

        rows.append(contentsOf: table.rows)

        if table.showFooters && table.columns.any({ $0.footer != nil }) {
            rows.append(TableRow.footer(table.columns.map { $0.footer ?? Text.empty }))
        }

        return rows
    }
}
