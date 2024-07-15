/// Represents a heavy border
public class HeavyBoxBorder: BoxBorder {
    public override var safeBorder: BoxBorder? {
        SquareBoxBorder()
    }
    
    public override func get(part: BoxBorderPart) -> String {
        switch part {
        case .topLeft:
            "╔"
        case .top:
            "═"
        case .topRight:
            "╗"
        case .left:
            "║"
        case .right:
            "║"
        case .bottomLeft:
            "╚"
        case .bottom:
            "═"
        case .bottomRight:
            "╝"
        }
    }
}
