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

public enum ColorSystem: Int {
    case noColor
    case threeBit
    case fourBit
    case eightBit
    case trueColor
}

public struct Color: Equatable {
    let number: UInt8?
    public let r: UInt8
    public let g: UInt8
    public let b: UInt8
        
    init(number: UInt8?, r: UInt8, g: UInt8, b: UInt8) {
        self.number = number
        self.r = r
        self.g = g
        self.b = b
    }
    
    /// Creates a new Color instance using RGB values
    /// - Parameters:
    ///   - r: The red component value
    ///   - g: The green component value
    ///   - b: The blur component value
    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.number = nil
        self.r = r
        self.g = g
        self.b = b
    }
    
    /// Creates a new Color instance from an xterm number
    /// - Parameter number: The xterm number
    /// - Returns: A new Color instance
    public static func fromNumber(number: UInt8) -> Color {
        ColorTable.getColor(number: number)
    }
    
    func getDistance(other: Color) -> Double {
        let rmean: Float = Float(other.r + self.r) / 2
        let r = Float(other.r - self.r)
        let g = Float(other.g - self.g)
        let b = Float(other.b - self.b)

        // TODO: Clean this up
        let a1 = (Int(((Float(512) + rmean) * r * r)) >> 8)
        let a2 = (4 * g * g)
        let a3 = (Int)((Float(767) - rmean) * b * b) >> 8
        return Double(Float(a1) + a2 + Float(a3))
    }
}
