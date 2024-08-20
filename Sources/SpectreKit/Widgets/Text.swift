/// A renderable piece of text.
public class Text: Renderable, Justifiable, Overflowable {
    var _paragraph: Paragraph

    /// Gets an empty ``Text`` instance.
    public static let empty: Text = Text("")

    /// Gets an instance of ``Text`` containing a new line.
    public static var newLine: Text {
        Text("\n", style: .plain)
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="Text"/> class.
    /// </summary>
    /// <param name="text">The text.</param>
    /// <param name="style">The style of the text or <see cref="Style.Plain"/> if <see langword="null"/>.</param>
    public init(_ text: String, style: Style? = nil) {
        _paragraph = Paragraph(text, style: style)
    }

    /// Gets or sets the text alignment.
    public var justification: Justify? {
        get { _paragraph.justification }
        set { _paragraph.justification = newValue }
    }

    /// Gets or sets the text overflow strategy.
    public var overflow: Overflow? {
        get { _paragraph.overflow }
        set { _paragraph.overflow = newValue }
    }

    /// Gets the character count.
    public var characterCount: Int { _paragraph.characterCount }

    /// Gets the number of lines in the text.
    public var lineCount: Int { _paragraph.lineCount }

    public func measure(options: RenderOptions, maxWidth: Int) -> Measurement {
        _paragraph.measure(options: options, maxWidth: maxWidth)
    }

    public func render(options: RenderOptions, maxWidth: Int) -> [Segment] {
        return _paragraph.render(options: options, maxWidth: maxWidth)
    }
}
