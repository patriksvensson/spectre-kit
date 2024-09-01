import Foundation

public class Panel: Renderable, BoxBordereable, Borderable, Paddable {
    private let content: Renderable
    private let edgeWidth: Int = 2

    public var border: BoxBorder = BoxBorder.square
    public var useSafeBorder: Bool = true
    public var borderStyle: Style?
    public var padding: Padding? = Padding(left: 1, top: 0, right: 1, bottom: 0)
    public var header: PanelHeader?
    public var expand: Bool = false

    public var width: Int?
    public var height: Int?

    public init(_ text: String) {
        self.content = Markup(text)
    }

    public init(_ content: Renderable) {
        self.content = content
    }

    public func measure(options: RenderOptions, maxWidth: Int) -> Measurement {
        let child = Padder(self.content, self.padding)
        return measure(options: options, maxWidth: maxWidth, child: child)
    }

    private func measure(options: RenderOptions, maxWidth: Int, child: Renderable) -> Measurement {
        let border = self.border.getSafeBorder(safe: !options.unicode && self.useSafeBorder)
        let edgeWidth = border is NoBoxBorder ? 0 : self.edgeWidth
        var childWidth = child.measure(options: options, maxWidth: maxWidth - edgeWidth)

        if var width = self.width {
            width -= edgeWidth
            if width > childWidth.max {
                childWidth = Measurement(min: childWidth.min, max: width)
            }
        }

        return Measurement(
            min: childWidth.min + edgeWidth,
            max: childWidth.max + edgeWidth
        )
    }

    public func render(options: RenderOptions, maxWidth: Int) -> [Segment] {
        let border = self.border.getSafeBorder(safe: !options.unicode && self.useSafeBorder)
        let borderStyle = self.borderStyle ?? Style.plain

        let showBorder = !(border is NoBoxBorder)
        let edgeWidth = showBorder ? self.edgeWidth : 0

        let child = Padder(self.content, self.padding)
        let width = measure(options: options, maxWidth: maxWidth, child: child)

        let panelWidth = min(!self.expand ? width.max : maxWidth, maxWidth)
        let innerWidth = panelWidth - edgeWidth

        var result: [Segment] = []

        if showBorder {
            self.addTopBorder(&result, options, border, borderStyle, panelWidth)
        } else {
            if self.header != nil {
                self.addTopBorder(&result, options, BoxBorder.none, borderStyle, panelWidth)
            }
        }

        let childSegments = child.render(options: options, maxWidth: innerWidth)
        let lines = Segment.splitLines(segments: childSegments, maxWidth: innerWidth)
        for (_, _, last, line) in lines.makeSequenceIterator() {

            if showBorder {
                result.append(
                    Segment.text(content: border.get(part: BoxBorderPart.left), style: borderStyle))
            }

            var content: [Segment] = []
            content.append(contentsOf: line.segments)

            // Do we need to pad the panel?
            let length = line.cellCount
            if length < innerWidth {
                let diff = innerWidth - length
                content.append(Segment.padding(count: diff))
            }

            result.append(contentsOf: content)

            if showBorder {
                result.append(
                    Segment.text(content: border.get(part: BoxBorderPart.right), style: borderStyle)
                )
            }

            // Don't emit a line break if this is the last
            // line, we're not showing the border, and we're
            // not rendering this inline.
            let emitLineBreak = !(last && !showBorder)
            if !emitLineBreak {
                continue
            }

            result.append(Segment.lineBreak)
        }

        // Panel bottom
        if showBorder {
            result.append(
                Segment.text(
                    content: border.get(part: BoxBorderPart.bottomLeft), style: borderStyle))
            result.append(
                Segment.text(
                    content: String(
                        repeating: border.get(part: BoxBorderPart.bottom),
                        count: panelWidth - self.edgeWidth),
                    style: borderStyle))
            result.append(
                Segment.text(
                    content: border.get(part: BoxBorderPart.bottomRight), style: borderStyle))
        }

        result.append(Segment.lineBreak)

        return result
    }

    private func addTopBorder(
        _ result: inout [Segment], _ options: RenderOptions,
        _ border: BoxBorder, _ borderStyle: Style, _ panelWidth: Int
    ) {
        let rule = Rule(title: self.header?.text)
        rule.style = borderStyle
        rule.border = border
        rule.titlePadding = 1
        rule.titleSpacing = 0
        rule.justification = self.header?.justification ?? Justify.left

        // Top left border
        var part = border.get(part: BoxBorderPart.topLeft)
        result.append(Segment.text(content: part, style: borderStyle))

        // Top border (and header text if specified)
        result.append(
            contentsOf: rule.render(options: options, maxWidth: panelWidth - 2)
                .filter { !$0.isLineBreak })

        // Top right border
        part = border.get(part: BoxBorderPart.topRight)
        result.append(Segment.text(content: part, style: borderStyle))
        result.append(Segment.lineBreak)
    }
}

public class PanelHeader {
    public var text: String
    public var justification: Justify?

    public init(_ text: String, _ justification: Justify? = nil) {
        self.text = text
        self.justification = justification
    }
}
