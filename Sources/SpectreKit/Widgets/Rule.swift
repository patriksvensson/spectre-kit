/// A renderable horizontal rule.
public class Rule: Renderable, BoxBordereable, Justifiable {
    /// Gets or sets the rule title markup text.
    public var title: String?

    /// Gets or sets the rule style.
    public var style: Style?

    /// Gets or sets the rule's title justification.
    public var justification: Justify?

    public var border: BoxBorder = SpectreKit.BoxBorder.square

    var titlePadding = 2
    var titleSpacing = 1

    /// Initializes a new instance of the ``Rule`` class.
    public init() {
    }

    /// Initializes a new instance of the ``Rule`` class
    /// - Parameter title: The rule title markup text.
    public init(title: String?) {
        self.title = title
    }

    public func render(options: RenderOptions, maxWidth: Int) -> [Segment] {
        let extraLength = (2 * titlePadding) + (2 * titleSpacing)

        guard let titleText = title, maxWidth <= extraLength else {
            return getLineWithoutTitle(options, maxWidth: maxWidth)
        }

        // Get the title and make sure it fits.
        var title = getTitleSegments(
            options: options, title: titleText, width: maxWidth - extraLength)
        if title.cellCount > maxWidth - extraLength {
            // Truncate the title
            title = title.truncateWithEllipsis(maxWidth: maxWidth - extraLength)
            if !title.isEmpty {
                // We couldn't fit the title at all.
                return getLineWithoutTitle(options, maxWidth: maxWidth)
            }
        }

        let (left, right) = getLineSegments(options: options, width: maxWidth, title: title)

        var segments: [Segment] = []
        segments.append(left)
        segments.append(contentsOf: title)
        segments.append(right)
        segments.append(.lineBreak)

        return segments
    }

    func getLineWithoutTitle(
        _ options: RenderOptions,
        maxWidth: Int
    ) -> [Segment] {
        let border = border.getSafeBorder(safe: !options.unicode)
        let text = String(
            repeating: border.get(part: BoxBorderPart.top),
            count: maxWidth)

        return [
            .text(content: text, style: style ?? .plain),
            .lineBreak,
        ]
    }

    func getTitleSegments(options: RenderOptions, title: String, width: Int) -> [Segment] {
        let trimmedTitle = title.normalizeNewLines().replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespaces)
        let markup = Markup(trimmedTitle, style: style)
        var singleOptions = options
        singleOptions.singleLine = true

        return markup.render(options: singleOptions, maxWidth: width)
    }

    func getLineSegments(options: RenderOptions, width: Int, title: [Segment]) -> (
        left: Segment, right: Segment
    ) {
        let titleLength = title.cellCount

        let border = border.getSafeBorder(safe: !options.unicode)
        let borderPart = border.get(part: .top)
        var left: Segment
        var right: Segment

        switch justification ?? .center {
        case .left:
            left = .text(
                content: String(repeating: borderPart, count: titlePadding)
                    + String(repeating: " ", count: titleSpacing), style: style ?? .plain)

            let rightLength = width - titleLength - left.cellCount - titleSpacing
            right = .text(
                content: String(repeating: " ", count: titleSpacing)
                    + String(repeating: borderPart, count: rightLength),
                style: style ?? .plain)

        case .center:
            let leftLength = ((width - titleLength) / 2) - titleSpacing
            left = .text(
                content: String(repeating: borderPart, count: leftLength)
                    + String(repeating: " ", count: titleSpacing),
                style: style ?? .plain)

            let rightLength = width - titleLength - left.cellCount - titleSpacing
            right = .text(
                content: String(repeating: " ", count: titleSpacing)
                    + String(repeating: borderPart, count: rightLength),
                style: style ?? .plain)
        case .right:
            right = .text(
                content: String(repeating: " ", count: titleSpacing)
                    + String(repeating: borderPart, count: titlePadding), style: style ?? .plain)

            let leftLength = width - titleLength - right.cellCount - titleSpacing
            left = .text(
                content: String(repeating: borderPart, count: leftLength)
                    + String(repeating: " ", count: titleSpacing), style: style ?? .plain)
        }
        return (left, right)
    }
}
