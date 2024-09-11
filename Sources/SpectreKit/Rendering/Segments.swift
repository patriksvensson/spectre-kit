// -----------------------------------------------------------------------------
// Segment

/// Represents a segment of text, whitespace, line breaks,
/// or terminal control sequences
public enum Segment: Equatable {
    /// An empty segment.
    case empty

    /// A linebreak segment.
    case lineBreak

    /// A segment containing whitespace.
    /// - Parameters:
    ///   - content: The whitespace content.
    case whitespace(content: String)

    /// A segment containing a control sequence code.
    /// - Parameters:
    ///   - code: The control sequence code
    case controlSequence(code: String)

    /// A segment containing text with an optional style.
    /// - Parameters:
    ///   - content: The text content.
    ///   - style: The text's style (optional).
    case text(content: String, style: Style?)

    var characterCount: Int {
        switch self {
        case let .controlSequence(text): text.count
        case let .text(text, _): text.count
        case let .whitespace(text): text.count
        case .empty: 0
        case .lineBreak: 1
        }
    }

    var cellCount: Int {
        switch self {
        case .controlSequence: 0
        case let .text(text, _): text.cellCount()
        case let .whitespace(text): text.cellCount()
        case .empty: 0
        case .lineBreak: 0
        }
    }

    var isLineBreak: Bool {
        switch self {
        case .lineBreak: true
        default: false
        }
    }

    var isWhitespace: Bool {
        switch self {
        case .whitespace: true
        default: false
        }
    }

    var isControlCode: Bool {
        switch self {
        case .controlSequence: true
        default: false
        }
    }

    func getText() -> String? {
        switch self {
        case let .controlSequence(value): value
        case .lineBreak: "\n"
        case let .text(value, _): value
        case let .whitespace(value): value
        default: nil
        }
    }

    func getStyle() -> Style {
        switch self {
        case let .text(_, style): style ?? Style.plain
        default: Style.plain
        }
    }

    func splitOverflow(maxWidth: Int, overflow: Overflow?) -> [Segment] {
        let overflow = overflow ?? .fold

        if self.cellCount <= maxWidth {
            return [self]
        }

        var result: [Segment] = []

        if max(0, maxWidth - 1) == 0 {
            result.append(Segment.empty)
        } else {
            switch self {
            case .controlSequence:
                result.append(self)
            case let .text(text, style):
                switch overflow {
                case .fold:
                    let split = Segment.splitSegment(text, maxCellLength: maxWidth)
                    for str in split {
                        result.append(Segment.text(content: str, style: style))
                    }
                case .crop:
                    // TODO: Won't work with wide characters
                    result.append(
                        Segment.text(
                            content: text.substring(end: maxWidth), style: style))
                case .ellipsis:
                    // TODO: Won't work with wide characters
                    result.append(
                        Segment.text(
                            content:
                                text.substring(end: maxWidth - 1) + "…",
                            style: style))
                }
            case let .whitespace(text):
                // TODO: Won't work with wide characters
                result.append(
                    Segment.whitespace(
                        content: text.substring(end: maxWidth)))
            default:
                break
            }
        }

        return result
    }

    func split(offset: Int) -> (Segment, Segment?) {
        if offset < 0 {
            return (self, nil)
        }

        if offset >= cellCount {
            return (self, nil)
        }

        var index = 0
        let text = getText() ?? ""

        if offset > 0 {
            var accumulated = 0
            for character in text {
                index += 1
                accumulated += character.cellSize()
                if accumulated >= offset {
                    break
                }
            }
        }

        return (
            Segment.text(content: text.substring(start: 0, end: index), style: self.getStyle()),
            Segment.text(
                content: text.substring(start: index, end: text.count - index),
                style: self.getStyle())
        )
    }

    /// Truncates the segment to the specified width.
    /// - Parameters:
    ///  - segment: The segment to truncate.
    ///  - maxWidth: The maximum width that the segment may occupy.
    /// - Returns: A new truncated segment, or `nil`
    static func truncate(segment: Segment?, maxWidth: Int) -> Segment? {
        guard let segment = segment else {
            return nil
        }

        if segment.cellCount <= maxWidth {
            return segment
        }

        func truncate(text: String, style: Style) -> Segment? {
            var builder = ""
            for character in text {
                let accumulatedCellWidth = builder.cellCount()
                if accumulatedCellWidth >= maxWidth {
                    break
                }
                builder.append(character)
            }

            if builder.count == 0 {
                return nil
            }

            return .text(content: builder, style: style)
        }

        switch segment {
        case .controlSequence:
            return nil
        case .empty:
            return nil
        case .lineBreak:
            return nil
        case .text(content: let text, let style):
            return truncate(text: text, style: style ?? .plain)
        case .whitespace(content: let text):
            return truncate(text: text, style: .plain)
        }
    }

    static func truncate(_ segments: [Segment], maxWidth: Int) -> [Segment] {
        var result: [Segment] = []

        var totalWidth = 0
        for segment in segments {
            let segmentCellWidth = segment.cellCount
            if totalWidth + segmentCellWidth > maxWidth {
                break
            }

            result.append(segment)
            totalWidth += segmentCellWidth
        }

        if result.count == 0 && segments.count > 0 {
            let segment = Segment.truncate(segment: segments.first, maxWidth: maxWidth)
            if let segment = segment {
                result.append(segment)
            }
        }

        return result
    }

    static func padding(count: Int) -> Segment {
        return Segment.whitespace(content: String(repeating: " ", count: count))
    }

    static func splitSegment(_ text: String, maxCellLength: Int) -> [String] {
        var list: [String] = []
        var length = 0
        var sb = ""
        for ch in text {
            let chw = Wcwidth.cellSize(ch)
            if length + chw > maxCellLength {
                list.append(sb)
                sb = ""
                length = 0
            }
            length += chw
            sb.append(ch)
        }
        list.append(sb)
        return list
    }

    static func splitLines(segments: [Segment]) -> [SegmentLine] {
        return splitLines(segments: segments, maxWidth: Int.max)
    }

    static func splitLines(segments: [Segment], maxWidth: Int) -> [SegmentLine] {
        var lines: [SegmentLine] = []
        var line = SegmentLine()

        var stack = Stack<Segment>(segments.reversed())
        while true {
            guard let segment: Segment = stack.pop() else {
                break
            }

            let segmentLength = segment.cellCount

            // Does this segment make the line exceed the max width?
            let lineLength = line.cellCount
            if lineLength + segmentLength > maxWidth {
                let diff = -(maxWidth - (lineLength + segmentLength))
                let offset = (segment.getText()?.cellCount() ?? 0) - diff

                let (first, second) = segment.split(offset: offset)

                line.append(segment: first)
                lines.append(line)
                line = SegmentLine()

                if second != nil {
                    stack.push(second.unsafelyUnwrapped)
                }

                continue
            }

            // Does the segment contain a newline?
            if var text = segment.getText() {
                if text.contains("\n") {
                    if text == "\n" {
                        if line.count != 0 || segment.isLineBreak {
                            lines.append(line)
                            line = SegmentLine()
                        }

                        continue
                    }

                    while true {
                        let parts = text.splitLines()
                        if parts.count > 0 {
                            if parts[0].count > 0 {
                                line.append(
                                    segment: Segment.text(
                                        content: parts[0], style: segment.getStyle()))
                            }
                        }

                        if parts.count > 1 {
                            if line.count > 0 {
                                lines.append(line)
                                line = SegmentLine()
                            }

                            text = parts[1...].joined()
                        } else {
                            break
                        }
                    }
                } else {
                    line.append(segment: segment)
                }
            }
        }

        if line.count > 0 {
            lines.append(line)
        }

        return lines
    }
}

// -----------------------------------------------------------------------------
// SegmentLine

/// Represents a line of terminal segments.
public struct SegmentLine {
    var segments: [Segment]

    var count: Int {
        return segments.count
    }

    init() {
        segments = []
    }

    var characterCount: Int {
        return segments.reduce(0) {
            $0 + $1.characterCount
        }
    }

    var cellCount: Int {
        return segments.reduce(0) {
            $0 + $1.cellCount
        }
    }

    mutating func append(segment: Segment) {
        segments.append(segment)
    }

    mutating func prepend(segment: Segment) {
        segments.insert(segment, at: 0)
    }
}

/// An iterator that iterates over ``SegmentLine``'s emitting line breaks as needed.
public struct SegmentLineIterator: IteratorProtocol, Sequence {
    public typealias Element = Segment

    private var lines: [SegmentLine]
    private var currentLine = 0
    private var currentIndex = -1
    private var lineBreakEmitted = false

    public init(lines: [SegmentLine]) {
        self.lines = lines
    }

    public mutating func next() -> Segment? {
        if currentLine > lines.count - 1 {
            return nil
        }

        currentIndex += 1

        // Did we go past the end of the line?
        if currentIndex > lines[currentLine].count - 1 {
            // We haven't just emitted a line break?
            if !lineBreakEmitted {
                // Got any more lines?
                if currentIndex + 1 > lines[currentLine].count - 1 {
                    // Only emit a line break if the next one isn't a line break.
                    if (currentLine + 1 <= lines.count - 1)
                        && lines[currentLine + 1].count > 0
                        && !lines[currentLine + 1].segments[0].isLineBreak
                    {
                        lineBreakEmitted = true
                        return Segment.lineBreak
                    }
                }
            }

            currentLine += 1
            currentIndex = 0
            lineBreakEmitted = false

            // No more lines?
            if currentLine > lines.count - 1 {
                return nil
            }

            // Nothing on the line?
            while currentIndex > lines[currentLine].count - 1 {
                currentLine += 1
                currentIndex = 0

                if currentLine > lines.count - 1 {
                    return nil
                }
            }
        }

        // Reset the line break flag
        lineBreakEmitted = false

        // Return the current segment
        return lines[currentLine]
            .segments[currentIndex]
    }
}

extension Array where Element == Segment {
    public var cellCount: Int {
        var total = 0
        for x in self {
            total += x.cellCount
        }
        return total
    }

    func truncate(maxWidth: Int) -> [Segment] {
        var result: [Segment] = []
        var totalWidth = 0
        for segment in self {
            let segmentCellWidth = segment.cellCount
            if totalWidth + segmentCellWidth > maxWidth {
                break
            }

            result.append(segment)
            totalWidth += segmentCellWidth
        }

        if result.count == 0 && self.count != 0 {
            if let first = self.first {
                if let segment = Segment.truncate(segment: first, maxWidth: maxWidth) {
                    result.append(segment)
                }
            }
        }
        return result
    }

    func truncateWithEllipsis(maxWidth: Int) -> [Segment] {
        if cellCount <= maxWidth {
            return self
        }

        var segments = truncate(maxWidth: maxWidth - 1).trimEnd()
        guard let first = segments.first else {
            return []
        }
        if case let Segment.text(_, style) = first {
            segments.append(.text(content: "…", style: style))
        } else {
            segments.append(.text(content: "…", style: .plain))
        }
        return segments
    }

    public func trimEnd() -> [Segment] {
        var stack: [Segment] = []
        var checkForWhitespace = true

        for segment in self.reversed() {
            if checkForWhitespace {
                if segment.isWhitespace {
                    continue
                }
                checkForWhitespace = false
            }

            stack.append(segment)
        }

        return stack
    }
}
