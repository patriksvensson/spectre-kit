/// Represents an old school ASCII border.
public class NoBoxBorder: BoxBorder {
    public override func get(part: BoxBorderPart) -> String {
        return " "
    }
}
