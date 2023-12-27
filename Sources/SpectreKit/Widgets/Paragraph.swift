import Foundation

/// Widget that renders styled text and auto wraps at line breaks as needed.
public struct Paragraph: Renderable {
    private var lines: [SegmentLine]

    // Gets the number of lines in the paragraph.
    var lineCount: Int {
        return lines.count
    }

    /// Gets the number of characters in the paragraph.
    var characterCount: Int {
        lines.reduce(0) {
            $0 + $1.characterCount
        }
    }

    public init() {
        self.lines = []
    }

    public init(_ text: String, style: Style? = nil) {
        self.lines = []
        self.append(text: text, style: style)
    }

    /// Appends text with an optional style to the paragraph.
    /// - Parameters:
    ///   - text: The text to add
    ///   - style: The text's style
    public mutating func append(text: String, style: Style? = nil) {
        for (_, isFirst, _, part) in text.splitLines().makeSequenceIterator() {
            if isFirst {
                // Append the segment to the last line
                var line = lines.last ?? SegmentLine()
                if part.isEmpty {
                    // Just an empty segment
                    // NOTE: Can this be skipped completely?
                    line.append(segment: Segment.empty)
                } else {
                    // Add all words as segments
                    for word in part.splitWords() {
                        if word.isWhitespace() {
                            line.append(segment: Segment.whitespace(content: word))
                        } else {
                            line.append(segment: Segment.text(content: word, style: style))
                        }
                    }
                }

                // Replace the last line
                if self.lines.last == nil {
                    self.lines.append(line)
                } else {
                    self.lines.indices.last.map { lines[$0] = line }
                }
            } else {
                var line = SegmentLine()
                if part.isEmpty {
                    // This is an empty line
                    line.append(segment: Segment.empty)
                } else {
                    // Add all words as segments
                    for word in part.splitWords() {
                        if word.isWhitespace() {
                            line.append(segment: Segment.whitespace(content: word))
                        } else {
                            line.append(segment: Segment.text(content: word, style: style))
                        }
                    }
                }

                self.lines.append(line)
            }
        }
    }

    public func measure(options: RenderOptions, maxWidth: Int) -> Measurement {
        if lines.count == 0 {
            return Measurement(min: 0, max: 0)
        }

        // Minimum width is the biggest segment in any line
        var min = 0
        for line in lines {
            for segment in line.segments {
                let cellCount = segment.cellCount
                if cellCount > min {
                    min = cellCount
                }
            }
        }

        // Maximum width is the biggest line
        let max = maxLineWidth()

        return Measurement(min: min, max: max)
    }

    public func render(options: RenderOptions, maxWidth: Int) -> [Segment] {
        if lines.count == 0 {
            return []
        }

        let lines = splitLines(maxWidth: maxWidth)

        // collect
        var result: [Segment] = []
        var ite = SegmentLineIterator(lines: lines)
        while let taa = ite.next() {
            result.append(taa)
        }

        return result
    }

    public func splitLines(maxWidth: Int) -> [SegmentLine] {
        if maxWidth <= 0 {
            return []
        }

        if maxLineWidth() <= maxWidth {
            // TODO: No need to clone
            return cloneSegments()
        }

        var lines: [SegmentLine] = []
        var line = SegmentLine()

        var iterator = SegmentLineIterator(lines: self.lines)
        var queue = Queue<Segment>()
        while true {
            var current: Segment?
            if queue.count == 0 {
                current = iterator.next()
                if current == nil {
                    break
                }
            } else {
                current = queue.dequeue()
            }

            guard let current else {
                fatalError("Iterator returned empty segment")
            }

            if current.isLineBreak {
                lines.append(line)
                line = SegmentLine()
                continue
            }

            var newLine = false

            let length = current.cellCount
            if length > maxWidth {
                // The current segment is longer than the width of the console,
                // so we will need to crop it up, into new segments.
                let segments = current.splitOverflow(maxWidth: maxWidth)
                if segments.count > 0 {
                    if line.cellCount + segments[0].cellCount > maxWidth {
                        lines.append(line)
                        line = SegmentLine()

                        for segment in segments {
                            queue.enqueue(segment)
                        }

                        continue
                    } else {
                        // Add the segment and push the rest of them to the queue.
                        line.append(segment: segments[0])
                        // TODO: Use something like "skip" here
                        var first = true
                        for segment in segments {
                            if !first {
                                queue.enqueue(segment)
                            }
                            first = false
                        }

                        continue
                    }
                }
            } else {
                if line.cellCount + length > maxWidth {
                    line.append(segment: Segment.empty)
                    lines.append(line)
                    line = SegmentLine()
                    newLine = true
                }
            }

            if newLine && current.isWhitespace {
                continue
            }

            line.append(segment: current)
        }

        // Flush remaining segments
        if line.count > 0 {
            lines.append(line)
        }

        return lines
    }

    mutating func addNewLine() -> SegmentLine {
        let line = SegmentLine()
        self.lines.append(line)
        return line
    }

    func maxLineWidth() -> Int {
        var max = 0
        for line in lines {
            let cellCount = line.cellCount
            if cellCount > max {
                max = cellCount
            }
        }
        return max
    }

    func cloneSegments() -> [SegmentLine] {
        var result: [SegmentLine] = []
        for line in lines {
            var newLine = SegmentLine()
            for segment in line.segments {
                newLine.append(segment: segment)
            }

            result.append(newLine)
        }

        return result
    }
}
