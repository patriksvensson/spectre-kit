import Foundation

// -----------------------------------------------------------------------------
// Renderer

/// Represents something that can render ``Renderable`` objects.
public protocol Renderer {
    /// Writes a ``Renderable``to the console.
    func write(_ renderable: Renderable, lineBreak: Bool)
}

// -----------------------------------------------------------------------------
// Console

/// A console capable of rendering ``Renderable`` objects to a ``Terminal``.
public class Console: Renderer {
    public let terminal: Terminal
    public let colors: ColorSystem

    /// Gets the width of the console.
    public var width: Int {
        return self.terminal.width
    }

    /// Gets the height of the console.
    public var height: Int {
        return self.terminal.height
    }

    public init(terminal: Terminal? = nil) {
        self.terminal = terminal ?? DefaultTerminal()
        self.colors = ColorSystemDetector.detect()
    }

    /// Writes a ``Renderable`` to stdout.
    public func write(_ renderable: Renderable, lineBreak: Bool = true) {
        self.terminal.write(render(renderable))
        if lineBreak {
            self.terminal.write("\n")
        }
    }

    func render(_ renderable: Renderable) -> String {
        let options = RenderOptions(terminal: self.terminal)
        let maxWidth = self.terminal.width

        if self.terminal.supportsAnsi {
            return AnsiBuilder.build(
                options: options,
                colors: colors,
                renderable: renderable,
                maxWidth: maxWidth)
        } else {
            var builder = ""
            for segment in renderable.render(options: options, maxWidth: maxWidth) {
                switch segment {
                case .lineBreak:
                    builder += "\n"
                case .whitespace(content: let content):
                    builder += content
                case .text(content: let content, _):
                    builder += content
                default:
                    continue
                }
            }

            return builder
        }
    }
}

extension Console {
    /// Writes the specified string value to the terminal.
    public func write(_ text: String) {
        write(Paragraph(text), lineBreak: false)
    }

    /// /// Writes the specified text, followed by the current line terminator, to the terminal.
    public func writeLine(_ text: String = "") {
        write(Paragraph(text), lineBreak: true)
    }

    /// Writes the specified markup to the terminal.
    public func markup(_ markup: String) {
        write(Markup(markup), lineBreak: false)
    }

    /// Writes the specified markup, followed by the current line terminator, to the terminal.
    public func markupLine(_ markup: String) {
        write(Markup(markup), lineBreak: true)
    }
}
