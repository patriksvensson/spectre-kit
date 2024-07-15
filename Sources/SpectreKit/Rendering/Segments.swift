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

    func splitOverflow(maxWidth: Int) -> [Segment] {
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
                result.append(
                    Segment.text(
                        content: text.substring(end: maxWidth), style: style))
            case let .whitespace(text):
                result.append(
                    Segment.whitespace(
                        content: text.substring(end: maxWidth)))
            default:
                break
            }
        }

        return result
    }
    
    /// Truncates the segment to the specified width.
    /// - Parameters:
    ///  - segment: The segment to truncate.
    ///  - maxWidth: The maximum width that the segment may occupy.
    /// - Returns: A new truncated segment, or `nil`
    public func truncate(maxWidth: Int) -> Segment {
        if cellCount < maxWidth {
            return self
        }
        func truncate(text: String, style: Style) -> Segment {
            var builder = ""
            for character in text {
                let accumulatedCellWidth = builder.cellCount
                if accumulatedCellWidth > maxWidth {
                    break
                }
                builder.append(character)
            }
            // TODO: if builder.count == 0 should we return .empty?
            return .text(content: builder, style: style)
        }
        switch self {
        case .controlSequence(code: _):
            fatalError("TODO")
        case .empty:
            return self
        case .lineBreak:
            fatalError("TODO: I think this should be empty")
            return .empty
        case .text(content: let text, style: let style):
            return truncate(text: text, style: style ?? .plain)
        case .whitespace(content: let text):
            return truncate(text: text, style: .plain)
        }
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
                let segment = first.truncate(maxWidth: maxWidth)
                result.append(segment)
            }
        }
        return result
    }
    
    func truncateWithEllipsis(maxWidth: Int) -> [Segment] {
        if cellCount < maxWidth {
            return self
        }
        var segments = truncate(maxWidth: maxWidth-1).trimEnd()
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
