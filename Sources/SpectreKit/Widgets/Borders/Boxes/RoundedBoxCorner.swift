/// Represents a rounded border.
public class RoundedBoxBorder: BoxBorder {
    public override func get(part: BoxBorderPart) -> String {
        switch part {
        case .topLeft:
            "╭"
        case .top:
            "─"
        case .topRight:
            "╮"
        case .left:
            "│"
        case .right:
            "│"
        case .bottomLeft:
            "╰"
        case .bottom:
            "─"
        case .bottomRight:
            "╯"
        }
    }
}
