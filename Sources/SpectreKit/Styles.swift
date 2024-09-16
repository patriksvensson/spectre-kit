import Foundation

// -----------------------------------------------------------------------------
// Style

/// Represents color and text decorations.
public struct Style: Equatable {
    /// The foreground color.
    public let foreground: Color?
    /// The background color.
    public let background: Color?
    /// The text decoration.
    public let decoration: Decoration

    /// A ``Style`` with the default colors
    /// and without text decoration
    public static let plain = Style()

    public init(foreground: Color? = nil, background: Color? = nil, decoration: Decoration? = nil) {
        self.foreground = foreground
        self.background = background
        self.decoration = decoration ?? []
    }

    /// Combines this style with another one.
    /// - Parameter style: The style to combine with this one
    /// - Returns: A new style representing the combination of this style and the other one.
    public func combine(style: Style) -> Style {
        var foreground = self.foreground
        if let otherForeground = style.foreground {
            if !otherForeground.isDefault {
                foreground = otherForeground
            }
        }

        var background = self.background
        if let otherBackground = style.background {
            if !otherBackground.isDefault {
                background = otherBackground
            }
        }

        return Style(
            foreground: foreground,
            background: background,
            decoration: self.decoration.intersection(style.decoration))
    }

    /// Converts the string representation of a style to
    /// it's ``Style`` equivalent.
    /// - Parameter text: The string containing the style to parse.
    /// - Returns: A ``Style`` equivalent of the text contained in the provided text.
    public static func parse(_ text: String) throws -> Style {
        return try StyleParser.parse(text)
    }
}

// -----------------------------------------------------------------------------
// StyleParser

struct StyleParser {
    static func parse(_ text: String) throws -> Style {
        let parts = text.splitWords(options: SplitOptions.removeEmpty)
        switch self.tryParse(parts) {
        case let .success(style):
            return style
        case let .failure(error):
            throw error
        }
    }

    static func tryParse(_ parts: [String]) -> Result<Style, StyleParserError> {
        var effectiveDecoration: Decoration = []
        var effectiveForeground: Color?
        var effectiveBackground: Color?

        var parsingForeground = true
        for part in parts {
            if part == "default" {
                continue
            }

            if part == "on" {
                parsingForeground = false
                continue
            }

            if let decoration = DecorationTable.getDecoration(name: part) {
                effectiveDecoration = effectiveDecoration.intersection(decoration)
                continue
            }

            if let color = ColorTable.getColor(name: part) {
                if parsingForeground {
                    if effectiveForeground != nil {
                        return .failure(.multipleForegrounds)
                    }
                    effectiveForeground = color
                } else {
                    if effectiveBackground != nil {
                        return .failure(.multipleBackground)
                    }
                    effectiveBackground = color
                }
            }
        }

        return .success(
            Style(
                foreground: effectiveForeground,
                background: effectiveBackground,
                decoration: effectiveDecoration
            ))
    }
}

// -----------------------------------------------------------------------------
// StyleParsingError

/// Represents an error that can occur during style parsing.
public enum StyleParserError: Error {
    /// More than one foreground was provided
    case multipleForegrounds
    /// More than one background was provided
    case multipleBackground
}

// -----------------------------------------------------------------------------
// Decoration

/// Represents text decoration.
/// Support for text decorations are up to the terminal.
public struct Decoration: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Bold text.
    public static let bold = Decoration(rawValue: 1 << 0)

    /// Dim or faint text.
    public static let dim = Decoration(rawValue: 1 << 1)

    /// Italic text.
    public static let italic = Decoration(rawValue: 1 << 2)

    /// Underlined text.
    public static let underline = Decoration(rawValue: 1 << 3)

    /// Swaps the foreground and background colors.
    public static let invert = Decoration(rawValue: 1 << 4)

    /// Hides the text.
    public static let conceal = Decoration(rawValue: 1 << 5)

    /// Makes text blink.
    /// Normally less than 150 blinks per minute.
    public static let slowBlink = Decoration(rawValue: 1 << 6)

    /// Makes text blink.
    /// Normally more than 150 blinks per minute.
    public static let rapidBlink = Decoration(rawValue: 1 << 7)

    /// Shows text with a horizontal line through the center.
    public static let strikethrough = Decoration(rawValue: 1 << 8)
}

// -----------------------------------------------------------------------------
// DecorationTable

struct DecorationTable {
    static let table: [String: Decoration] = [
        "none": [],
        "bold": Decoration.bold,
        "b": Decoration.bold,
        "dim": Decoration.dim,
        "italic": Decoration.italic,
        "i": Decoration.italic,
        "underline": Decoration.underline,
        "u": Decoration.underline,
        "invert": Decoration.invert,
        "reverse": Decoration.invert,
        "conceal": Decoration.conceal,
        "blink": Decoration.slowBlink,
        "slowblink": Decoration.slowBlink,
        "rapidblink": Decoration.rapidBlink,
        "strike": Decoration.strikethrough,
        "strikethrough": Decoration.strikethrough,
        "s": Decoration.strikethrough,
    ]

    static func getDecoration(name: String) -> Decoration? {
        return self.table[name]
    }
}
