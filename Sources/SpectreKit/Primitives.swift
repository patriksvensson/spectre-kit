import Foundation

/// Represents color and text decorations.
public struct Style: Equatable {
    public let foreground: Color?
    public let background: Color?
    public let decoration: Decoration

    public static let plain = Style()
    
    public init(foreground: Color? = nil, background: Color? = nil, decoration: Decoration? = nil) {
        self.foreground = foreground
        self.background = background
        self.decoration = decoration ?? []
    }
}

/// Represents text decoration.
/// Support for text decorations are up to the terminal.
public struct Decoration: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let bold = Decoration(rawValue: 1 << 0)
    public static let dim = Decoration(rawValue: 1 << 1)
    public static let italic = Decoration(rawValue: 1 << 2)
    public static let underline = Decoration(rawValue: 1 << 3)
    public static let invert = Decoration(rawValue: 1 << 4)
    public static let conceal = Decoration(rawValue: 1 << 5)
    public static let slowBlink = Decoration(rawValue: 1 << 6)
    public static let rapidBlink = Decoration(rawValue: 1 << 7)
    public static let strikethrough = Decoration(rawValue: 1 << 8)
}

/// Represents a color system
public enum ColorSystem {
    case standard
    case eightBit
    case trueColor
}

/// Represents a color
public enum Color: Equatable {
    case `default`
    case number(UInt8)
    case rgb(UInt8, UInt8, UInt8)
    
    public var isDefault: Bool {
        return switch self {
        case .default: true
        default: false
        }
    }
    
    public var system: ColorSystem {
        return switch self {
        case .default: ColorSystem.standard
        case let .number(number):
            switch number {
            case 0...15: ColorSystem.standard
            default: ColorSystem.eightBit
            }
        case .rgb(_,_,_): ColorSystem.trueColor
        }
    }

    public func downgrade(to: ColorSystem) -> Color {
        if !self.isDefault {
            switch to {
            case .standard:
                if system != .standard {
                    return downgrade(to: .standard, triplet: getTriplet())
                }
            case .eightBit:
                if system != .standard && system != .eightBit {
                    return downgrade(to: .eightBit, triplet: getTriplet())
                }
            case ColorSystem.trueColor:
                if system != .trueColor {
                    guard let (r, g, b) = getTriplet() else {
                        return self
                    }
                    return Color.rgb(r, g, b)
                }
            }
        }
        
        return self
    }
    
    func downgrade(to: ColorSystem, triplet: (UInt8, UInt8, UInt8)?) -> Color {
        guard let triplet = triplet else {
            return self
        }

        let colorNumber = ColorPalette.getNumber(system: to, color: triplet)
        guard let colorNumber else {
            fatalError("Could not get closest color")
        }
        return Color.number(colorNumber)
    }
    
    func getTriplet() -> (UInt8, UInt8, UInt8)? {
        return switch self {
        case let .rgb(r, g, b): (r, g, b)
        case let .number(number): ColorPalette.eightBit[safe: Int(number)]
        default: nil
        }
    }
}
