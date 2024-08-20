/// Represents an invisible border.
public class NoTableBorder: TableBorder {

    public override var visible: Bool {
        get {
            false
        }
        set {}
    }

    public override var supportsRowSeparator: Bool {
        get {
            false
        }
        set {

        }
    }

    public override func get(part: TableBorderPart) -> String {
        return " "
    }
}
