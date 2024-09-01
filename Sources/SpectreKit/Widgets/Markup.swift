import Foundation

// -----------------------------------------------------------------------------
// Markup

/// Widget that renders markup text
public class Markup: Renderable, Justifiable, Overflowable {
    var paragraph: Paragraph

    /// Gets or sets the text alignment.
    public var justification: Justify? {
        get { self.paragraph.justification }
        set { self.paragraph.justification = newValue }
    }

    /// Gets or sets the text overflow strategy.
    public var overflow: Overflow? {
        get { self.paragraph.overflow }
        set { self.paragraph.overflow = newValue }
    }

    public init(_ markup: String, style: Style? = nil) {
        self.paragraph = try! MarkupParser.parse(text: markup, style: style)
    }

    public func measure(options: RenderOptions, maxWidth: Int) -> Measurement {
        return paragraph.measure(options: options, maxWidth: maxWidth)
    }

    public func render(options: RenderOptions, maxWidth: Int) -> [Segment] {
        return paragraph.render(options: options, maxWidth: maxWidth)
    }
}

// -----------------------------------------------------------------------------
// MarkupError

enum MarkupError: Error {
    case malformed(position: Int)
    case unescaped(position: Int)
    case closingTagNotExpected
}

extension MarkupError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .malformed(position):
            return "Encountered malformed markup tag at position \(position)"
        case let .unescaped(position):
            return "Encountered unescaped ']' token at position \(position)"
        case .closingTagNotExpected:
            return "Encountered closing tag when none was expected"
        }
    }
}

extension MarkupError: LocalizedError {
    public var errorDescription: String? {
        return self.description
    }
}

// -----------------------------------------------------------------------------
// MarkupToken

enum MarkupToken: Equatable {
    case open([String])
    case close
    case text(String)
}

// -----------------------------------------------------------------------------
// MarkupParser

fileprivate struct MarkupParser {
    public static func parse(text: String, style: Style? = nil) throws -> Paragraph {
        var tokenizer = MarkupTokenizer(text: text)
        var stack = Stack<Style>()
        let style = style ?? Style.plain
        var result = Paragraph()

        while try tokenizer.moveNext() {
            guard let token = tokenizer.current else {
                break
            }

            switch token {
            case let .open(styles):
                switch StyleParser.tryParse(styles) {
                case let .success(parsedStyle):
                    stack.push(parsedStyle)
                case let .failure(error):
                    throw error
                }
            case .close:
                if stack.count == 0 {
                    throw MarkupError.closingTagNotExpected
                }
                stack.pop()
            case let .text(text):
                // Combine all styles in reverse order
                var current = style
                for item in stack.reversed() {
                    current = current.combine(style: item)
                }

                var appliedStyle: Style? = current
                if current.foreground == nil && current.background == nil
                    && current.decoration == []
                {
                    appliedStyle = nil
                }

                result.append(text: text, style: appliedStyle)
            }
        }

        return result
    }
}

// -----------------------------------------------------------------------------
// MarkupTokenizer

fileprivate struct MarkupTokenizer {
    var buffer: StringBuffer
    private(set) var current: MarkupToken?

    init(text: String) {
        buffer = StringBuffer(text: text)
    }

    public mutating func moveNext() throws -> Bool {
        if buffer.reachedEnd {
            return false
        }

        // Read the next token
        let current = buffer.peek()
        if current == "[" {
            try readMarkup()
        } else {
            try readText()
        }

        return true
    }

    mutating func readMarkup() throws {
        let position = self.buffer.position
        self.buffer.consume()

        if self.buffer.reachedEnd {
            throw MarkupError.malformed(position: position)
        }

        var current = self.buffer.peek()
        if current == "[" {

        }

        switch current {
        case "[":
            // No markup but instead escaped markup in text.
            self.buffer.consume()
            self.current = .text("[")
            return
        case "/":
            self.buffer.consume()
            if self.buffer.reachedEnd {
                throw MarkupError.malformed(position: position)
            }

            current = self.buffer.peek()
            if current != "]" {
                throw MarkupError.malformed(position: position)
            }

            self.buffer.consume()  // Consume the "]"
            self.current = .close
            return
        default:
            break
        }

        // Read the "content" of the markup until we find the end-of-markup
        var builder = ""
        var encounteredOpening = false
        var encounteredClosing = false
        while !self.buffer.reachedEnd {
            let canContainMarkup =
                builder.splitWords(options: SplitOptions.removeEmpty).last?.starts(with: "")
                ?? false
            let current = self.buffer.peek()

            if canContainMarkup {
                if current == "]" && !encounteredOpening {
                    if encounteredClosing {
                        builder.append(self.buffer.read())
                        encounteredClosing = false
                        continue
                    }

                    self.buffer.consume()
                    encounteredClosing = true
                    continue
                }

                if current == "[" && !encounteredClosing {
                    if encounteredOpening {
                        builder.append(self.buffer.read())
                        encounteredOpening = false
                        continue
                    }

                    self.buffer.consume()
                    encounteredOpening = true
                    continue
                }
            } else {
                if current == "]" {
                    self.buffer.consume()
                    encounteredClosing = true
                } else if current == "[" {
                    self.buffer.consume()
                    encounteredOpening = true
                }
            }

            if encounteredClosing {
                break
            }

            if encounteredOpening {
                throw MarkupError.malformed(position: position)
            }

            builder.append(self.buffer.read())
        }

        if self.buffer.reachedEnd {
            throw MarkupError.malformed(position: position)
        }

        self.current = .open(builder.splitWords(options: SplitOptions.removeEmpty))
    }

    mutating func readText() throws {
        let position = buffer.position
        var builder = ""

        var encounteredClosing = false

        while !self.buffer.reachedEnd {
            let current = buffer.peek()
            if current == "[" {
                break
            }

            if current == "]" {
                if encounteredClosing {
                    self.buffer.consume()
                    encounteredClosing = false
                    continue
                }

                encounteredClosing = true
            } else {
                if encounteredClosing {
                    throw MarkupError.unescaped(position: position)
                }
            }

            builder.append(self.buffer.read())
        }

        if encounteredClosing {
            throw MarkupError.unescaped(position: position)
        }

        self.current = .text(builder)
    }
}

// -----------------------------------------------------------------------------
// StringBuffer

fileprivate struct StringBuffer {
    let buffer: String
    private(set) var position: Int

    var reachedEnd: Bool {
        self.position >= self.buffer.count
    }

    var current: Character {
        self.buffer[self.position]
    }

    init(text: String) {
        self.buffer = text
        self.position = 0
    }

    public func peek(offset: Int = 0) -> Character {
        guard offset >= 0 else {
            fatalError("Peeking with a negative offset is not supported")
        }

        let pos = self.position + offset
        if pos >= self.buffer.count {
            return "\0"
        }

        return buffer[pos]
    }

    @discardableResult
    public mutating func read() -> Character {
        let result = buffer[self.position]
        if result != "\0" {
            self.position += 1
        }
        return result
    }

    public mutating func consume(count: Int = 1) {
        for _ in 0...count - 1 {
            self.read()
        }
    }
}
