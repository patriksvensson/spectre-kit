/// Represents a heavy border.
public class HeavyTableBorder: TableBorder {
    
    public override var safeBorder: TableBorder? {
        TableBorder.square
    }

    public override func get(part: TableBorderPart) -> String {
        switch part {
            case .headerTopLeft: "┏"
            case .headerTop: "━"
            case .headerTopSeparator: "┳"
            case .headerTopRight: "┓"
            case .headerLeft: "┃"
            case .headerSeparator: "┃"
            case .headerRight: "┃"
            case .headerBottomLeft: "┣"
            case .headerBottom: "━"
            case .headerBottomSeparator: "╋"
            case .headerBottomRight: "┫"
            case .cellLeft: "┃"
            case .cellSeparator: "┃"
            case .cellRight: "┃"
            case .footerTopLeft: "┣"
            case .footerTop: "━"
            case .footerTopSeparator: "╋"
            case .footerTopRight: "┫"
            case .footerBottomLeft: "┗"
            case .footerBottom: "━"
            case .footerBottomSeparator: "┻"
            case .footerBottomRight: "┛"
            case .rowLeft: "┣"
            case .rowCenter: "━"
            case .rowSeparator: "╋"
            case .rowRight: "┫"
        }
    }
}
