// -----------------------------------------------------------------------------
// Grid

public class Grid: Renderable, Expandable, Alignable {
    private var columns: [GridColumn]
    private var rows: [GridRow]
    private var padRightCell: Bool
    private var table: Table?

    public var expand: Bool
    public var alignment: Justify?
    public var width: Int?

    public init() {
        self.expand = false
        self.columns = []
        self.rows = []
        self.padRightCell = false
    }

    @discardableResult
    public func addColumn() -> Self {
        self.table = nil
        return addColumn(GridColumn())
    }

    @discardableResult
    public func addColumn(_ column: GridColumn) -> Self {
        precondition(self.rows.count == 0, "Cannot add new columns to grid with existing rows")
        self.table = nil
        self.padRightCell = column.hasExplicitPadding
        self.columns.append(column)
        return self
    }

    @discardableResult
    public func addRow(_ columns: [any Renderable]) -> Self {
        self.table = nil
        self.rows.append(GridRow(columns))
        return self
    }

    @discardableResult
    public func addRow(_ columns: any Renderable...) -> Self {
        precondition(
            columns.count > self.columns.count,
            "The number of row columns are greater than the number of grid columns")
        self.table = nil
        self.rows.append(GridRow(columns))
        return self
    }

    public func measure(options: RenderOptions, maxWidth: Int) -> Measurement {
        return getInner().measure(options: options, maxWidth: maxWidth)
    }

    public func render(options: RenderOptions, maxWidth: Int) -> [Segment] {
        return getInner().render(options: options, maxWidth: maxWidth)
    }

    private func getInner() -> Table {
        if let table = self.table {
            return table
        }

        let table = buildTable()
        self.table = table
        return table
    }

    private func buildTable() -> Table {
        let table = Table()
        table.border = TableBorder.none
        table.showHeaders = false
        table.isGrid = true
        table.padRightCell = self.padRightCell
        table.width = self.width

        for column in self.columns {
            table.addColumn(
                TableColumn("")
                    .width(column.width)
                    .noWrap(column.noWrap)
                    .padding(column.padding ?? Padding(left: 0, top: 0, right: 2, bottom: 0))
                    .alignment(column.alignment))
        }

        for row in self.rows {
            table.addRow(row.items)
        }

        return table
    }
}

extension Grid {
    @discardableResult
    public func addColumns(_ count: Int) -> Self {
        for _ in 0..<count {
            self.addColumn()
        }
        return self
    }

    @discardableResult
    public func addColumns(_ columns: GridColumn...) -> Self {
        for column in columns {
            self.addColumn(column)
        }
        return self
    }

    @discardableResult
    public func addEmptyRow() -> Self {
        var columns: [any Renderable] = []
        for _ in 0..<self.columns.count {
            columns.append(Text.empty)
        }
        self.addRow(columns)
        return self
    }

    @discardableResult
    public func addRow(_ columns: String...) -> Self {
        self.addRow(columns.map { Markup($0) })
        return self
    }

    @discardableResult
    public func width(_ width: Int) -> Self {
        self.width = width
        return self
    }
}

// -----------------------------------------------------------------------------
// GridColumn

public class GridColumn: Column {
    public var noWrap: Bool
    public var width: Int?
    public var padding: Padding?
    public var alignment: Justify?

    var hasExplicitPadding: Bool {
        return padding == nil
    }

    public init() {
        self.noWrap = false
    }
}

// -----------------------------------------------------------------------------
// GridRow

public class GridRow {
    public var items: [any Renderable]

    public init(_ items: [any Renderable]) {
        self.items = items
    }

    public func append(_ item: Renderable) {
        self.items.append(item)
    }
}
