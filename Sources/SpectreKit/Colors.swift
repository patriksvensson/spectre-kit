import Foundation

// -----------------------------------------------------------------------------
// Color

/// Represents a color
public enum Color: Equatable {
    case `default`
    case number(UInt8)
    case rgb(UInt8, UInt8, UInt8)

    /// Returns whether or not the color is a default color.
    public var isDefault: Bool {
        return switch self {
        case .default: true
        default: false
        }
    }

    /// Gets the ``ColorSystem`` that this color belongs to.
    public var system: ColorSystem {
        return switch self {
        case .default: ColorSystem.standard
        case let .number(number):
            switch number {
            case 0...15: ColorSystem.standard
            default: ColorSystem.eightBit
            }
        case .rgb: ColorSystem.trueColor
        }
    }

    /// Converts the color to another ``ColorSystem``.
    public func convert(to: ColorSystem) -> Color {
        if !self.isDefault {
            switch to {
            case .noColor:
                return Color.default
            case .standard:
                if system != .standard {
                    return convert(to: .standard, triplet: getTriplet())
                }
            case .eightBit:
                if system != .standard && system != .eightBit {
                    return convert(to: .eightBit, triplet: getTriplet())
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

    func convert(to: ColorSystem, triplet: (UInt8, UInt8, UInt8)?) -> Color {
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

// -----------------------------------------------------------------------------
// ColorSystem

/// Represents a color system
public enum ColorSystem {
    case noColor
    case standard
    case eightBit
    case trueColor
}

// -----------------------------------------------------------------------------
// ColorSystemDetector

struct ColorSystemDetector {
    public static func detect() -> ColorSystem {
        if let _ = ProcessInfo.processInfo.environment["NO_COLOR"] {
            return .noColor
        }

        if let colorTerm = ProcessInfo.processInfo.environment["COLORTERM"] {
            if colorTerm == "truecolor" || colorTerm == "24bit" {
                return .trueColor
            }
        }

        return .eightBit
    }
}

// -----------------------------------------------------------------------------
// ColorTable

struct ColorTable {
    static let table: [String: UInt8] = [
        "black": 0,
        "red": 1,
        "green": 2,
        "yellow": 3,
        "blue": 4,
        "magenta": 5,
        "cyan": 6,
        "white": 7,
        "bright_black": 8,
        "bright_red": 9,
        "bright_green": 10,
        "bright_yellow": 11,
        "bright_blue": 12,
        "bright_magenta": 13,
        "bright_cyan": 14,
        "bright_white": 15,
        "grey0": 16,
        "gray0": 16,
        "navy_blue": 17,
        "dark_blue": 18,
        "blue3": 20,
        "blue1": 21,
        "dark_green": 22,
        "deep_sky_blue4": 25,
        "dodger_blue3": 26,
        "dodger_blue2": 27,
        "green4": 28,
        "spring_green4": 29,
        "turquoise4": 30,
        "deep_sky_blue3": 32,
        "dodger_blue1": 33,
        "green3": 40,
        "spring_green3": 41,
        "dark_cyan": 36,
        "light_sea_green": 37,
        "deep_sky_blue2": 38,
        "deep_sky_blue1": 39,
        "spring_green2": 47,
        "cyan3": 43,
        "dark_turquoise": 44,
        "turquoise2": 45,
        "green1": 46,
        "spring_green1": 48,
        "medium_spring_green": 49,
        "cyan2": 50,
        "cyan1": 51,
        "dark_red": 88,
        "deep_pink4": 125,
        "purple4": 55,
        "purple3": 56,
        "blue_violet": 57,
        "orange4": 94,
        "grey37": 59,
        "gray37": 59,
        "medium_purple4": 60,
        "slate_blue3": 62,
        "royal_blue1": 63,
        "chartreuse4": 64,
        "dark_sea_green4": 71,
        "pale_turquoise4": 66,
        "steel_blue": 67,
        "steel_blue3": 68,
        "cornflower_blue": 69,
        "chartreuse3": 76,
        "cadet_blue": 73,
        "sky_blue3": 74,
        "steel_blue1": 81,
        "pale_green3": 114,
        "sea_green3": 78,
        "aquamarine3": 79,
        "medium_turquoise": 80,
        "chartreuse2": 112,
        "sea_green2": 83,
        "sea_green1": 85,
        "aquamarine1": 122,
        "dark_slate_gray2": 87,
        "dark_magenta": 91,
        "dark_violet": 128,
        "purple": 129,
        "light_pink4": 95,
        "plum4": 96,
        "medium_purple3": 98,
        "slate_blue1": 99,
        "yellow4": 106,
        "wheat4": 101,
        "grey53": 102,
        "gray53": 102,
        "light_slate_grey": 103,
        "light_slate_gray": 103,
        "medium_purple": 104,
        "light_slate_blue": 105,
        "dark_olive_green3": 149,
        "dark_sea_green": 108,
        "light_sky_blue3": 110,
        "sky_blue2": 111,
        "dark_sea_green3": 150,
        "dark_slate_gray3": 116,
        "sky_blue1": 117,
        "chartreuse1": 118,
        "light_green": 120,
        "pale_green1": 156,
        "dark_slate_gray1": 123,
        "red3": 160,
        "medium_violet_red": 126,
        "magenta3": 164,
        "dark_orange3": 166,
        "indian_red": 167,
        "hot_pink3": 168,
        "medium_orchid3": 133,
        "medium_orchid": 134,
        "medium_purple2": 140,
        "dark_goldenrod": 136,
        "light_salmon3": 173,
        "rosy_brown": 138,
        "grey63": 139,
        "gray63": 139,
        "medium_purple1": 141,
        "gold3": 178,
        "dark_khaki": 143,
        "navajo_white3": 144,
        "grey69": 145,
        "gray69": 145,
        "light_steel_blue3": 146,
        "light_steel_blue": 147,
        "yellow3": 184,
        "dark_sea_green2": 157,
        "light_cyan3": 152,
        "light_sky_blue1": 153,
        "green_yellow": 154,
        "dark_olive_green2": 155,
        "dark_sea_green1": 193,
        "pale_turquoise1": 159,
        "deep_pink3": 162,
        "magenta2": 200,
        "hot_pink2": 169,
        "orchid": 170,
        "medium_orchid1": 207,
        "orange3": 172,
        "light_pink3": 174,
        "pink3": 175,
        "plum3": 176,
        "violet": 177,
        "light_goldenrod3": 179,
        "tan": 180,
        "misty_rose3": 181,
        "thistle3": 182,
        "plum2": 183,
        "khaki3": 185,
        "light_goldenrod2": 222,
        "light_yellow3": 187,
        "grey84": 188,
        "gray84": 188,
        "light_steel_blue1": 189,
        "yellow2": 190,
        "dark_olive_green1": 192,
        "honeydew2": 194,
        "light_cyan1": 195,
        "red1": 196,
        "deep_pink2": 197,
        "deep_pink1": 199,
        "magenta1": 201,
        "orange_red1": 202,
        "indian_red1": 204,
        "hot_pink": 206,
        "dark_orange": 208,
        "salmon1": 209,
        "light_coral": 210,
        "pale_violet_red1": 211,
        "orchid2": 212,
        "orchid1": 213,
        "orange1": 214,
        "sandy_brown": 215,
        "light_salmon1": 216,
        "light_pink1": 217,
        "pink1": 218,
        "plum1": 219,
        "gold1": 220,
        "navajo_white1": 223,
        "misty_rose1": 224,
        "thistle1": 225,
        "yellow1": 226,
        "light_goldenrod1": 227,
        "khaki1": 228,
        "wheat1": 229,
        "cornsilk1": 230,
        "grey100": 231,
        "gray100": 231,
        "grey3": 232,
        "gray3": 232,
        "grey7": 233,
        "gray7": 233,
        "grey11": 234,
        "gray11": 234,
        "grey15": 235,
        "gray15": 235,
        "grey19": 236,
        "gray19": 236,
        "grey23": 237,
        "gray23": 237,
        "grey27": 238,
        "gray27": 238,
        "grey30": 239,
        "gray30": 239,
        "grey35": 240,
        "gray35": 240,
        "grey39": 241,
        "gray39": 241,
        "grey42": 242,
        "gray42": 242,
        "grey46": 243,
        "gray46": 243,
        "grey50": 244,
        "gray50": 244,
        "grey54": 245,
        "gray54": 245,
        "grey58": 246,
        "gray58": 246,
        "grey62": 247,
        "gray62": 247,
        "grey66": 248,
        "gray66": 248,
        "grey70": 249,
        "gray70": 249,
        "grey74": 250,
        "gray74": 250,
        "grey78": 251,
        "gray78": 251,
        "grey82": 252,
        "gray82": 252,
        "grey85": 253,
        "gray85": 253,
        "grey89": 254,
        "gray89": 254,
        "grey93": 255,
        "gray93": 255,
    ]

    public static func getColor(name: String) -> Color? {
        guard let number = self.table[name] else {
            return .none
        }
        return Color.number(number)
    }
}

// -----------------------------------------------------------------------------
// ColorPalette

struct ColorPalette {
    static let standard: [(UInt8, UInt8, UInt8)] = [
        (0, 0, 0),
        (170, 0, 0),
        (0, 170, 0),
        (170, 85, 0),
        (0, 0, 170),
        (170, 0, 170),
        (0, 170, 170),
        (170, 170, 170),
        (85, 85, 85),
        (255, 85, 85),
        (85, 255, 85),
        (255, 255, 85),
        (85, 85, 255),
        (255, 85, 255),
        (85, 255, 255),
        (255, 255, 255),
    ]

    static let eightBit: [(UInt8, UInt8, UInt8)] = [
        (0, 0, 0),
        (128, 0, 0),
        (0, 128, 0),
        (128, 128, 0),
        (0, 0, 128),
        (128, 0, 128),
        (0, 128, 128),
        (192, 192, 192),
        (128, 128, 128),
        (255, 0, 0),
        (0, 255, 0),
        (255, 255, 0),
        (0, 0, 255),
        (255, 0, 255),
        (0, 255, 255),
        (255, 255, 255),
        (0, 0, 0),
        (0, 0, 95),
        (0, 0, 135),
        (0, 0, 175),
        (0, 0, 215),
        (0, 0, 255),
        (0, 95, 0),
        (0, 95, 95),
        (0, 95, 135),
        (0, 95, 175),
        (0, 95, 215),
        (0, 95, 255),
        (0, 135, 0),
        (0, 135, 95),
        (0, 135, 135),
        (0, 135, 175),
        (0, 135, 215),
        (0, 135, 255),
        (0, 175, 0),
        (0, 175, 95),
        (0, 175, 135),
        (0, 175, 175),
        (0, 175, 215),
        (0, 175, 255),
        (0, 215, 0),
        (0, 215, 95),
        (0, 215, 135),
        (0, 215, 175),
        (0, 215, 215),
        (0, 215, 255),
        (0, 255, 0),
        (0, 255, 95),
        (0, 255, 135),
        (0, 255, 175),
        (0, 255, 215),
        (0, 255, 255),
        (95, 0, 0),
        (95, 0, 95),
        (95, 0, 135),
        (95, 0, 175),
        (95, 0, 215),
        (95, 0, 255),
        (95, 95, 0),
        (95, 95, 95),
        (95, 95, 135),
        (95, 95, 175),
        (95, 95, 215),
        (95, 95, 255),
        (95, 135, 0),
        (95, 135, 95),
        (95, 135, 135),
        (95, 135, 175),
        (95, 135, 215),
        (95, 135, 255),
        (95, 175, 0),
        (95, 175, 95),
        (95, 175, 135),
        (95, 175, 175),
        (95, 175, 215),
        (95, 175, 255),
        (95, 215, 0),
        (95, 215, 95),
        (95, 215, 135),
        (95, 215, 175),
        (95, 215, 215),
        (95, 215, 255),
        (95, 255, 0),
        (95, 255, 95),
        (95, 255, 135),
        (95, 255, 175),
        (95, 255, 215),
        (95, 255, 255),
        (135, 0, 0),
        (135, 0, 95),
        (135, 0, 135),
        (135, 0, 175),
        (135, 0, 215),
        (135, 0, 255),
        (135, 95, 0),
        (135, 95, 95),
        (135, 95, 135),
        (135, 95, 175),
        (135, 95, 215),
        (135, 95, 255),
        (135, 135, 0),
        (135, 135, 95),
        (135, 135, 135),
        (135, 135, 175),
        (135, 135, 215),
        (135, 135, 255),
        (135, 175, 0),
        (135, 175, 95),
        (135, 175, 135),
        (135, 175, 175),
        (135, 175, 215),
        (135, 175, 255),
        (135, 215, 0),
        (135, 215, 95),
        (135, 215, 135),
        (135, 215, 175),
        (135, 215, 215),
        (135, 215, 255),
        (135, 255, 0),
        (135, 255, 95),
        (135, 255, 135),
        (135, 255, 175),
        (135, 255, 215),
        (135, 255, 255),
        (175, 0, 0),
        (175, 0, 95),
        (175, 0, 135),
        (175, 0, 175),
        (175, 0, 215),
        (175, 0, 255),
        (175, 95, 0),
        (175, 95, 95),
        (175, 95, 135),
        (175, 95, 175),
        (175, 95, 215),
        (175, 95, 255),
        (175, 135, 0),
        (175, 135, 95),
        (175, 135, 135),
        (175, 135, 175),
        (175, 135, 215),
        (175, 135, 255),
        (175, 175, 0),
        (175, 175, 95),
        (175, 175, 135),
        (175, 175, 175),
        (175, 175, 215),
        (175, 175, 255),
        (175, 215, 0),
        (175, 215, 95),
        (175, 215, 135),
        (175, 215, 175),
        (175, 215, 215),
        (175, 215, 255),
        (175, 255, 0),
        (175, 255, 95),
        (175, 255, 135),
        (175, 255, 175),
        (175, 255, 215),
        (175, 255, 255),
        (215, 0, 0),
        (215, 0, 95),
        (215, 0, 135),
        (215, 0, 175),
        (215, 0, 215),
        (215, 0, 255),
        (215, 95, 0),
        (215, 95, 95),
        (215, 95, 135),
        (215, 95, 175),
        (215, 95, 215),
        (215, 95, 255),
        (215, 135, 0),
        (215, 135, 95),
        (215, 135, 135),
        (215, 135, 175),
        (215, 135, 215),
        (215, 135, 255),
        (215, 175, 0),
        (215, 175, 95),
        (215, 175, 135),
        (215, 175, 175),
        (215, 175, 215),
        (215, 175, 255),
        (215, 215, 0),
        (215, 215, 95),
        (215, 215, 135),
        (215, 215, 175),
        (215, 215, 215),
        (215, 215, 255),
        (215, 255, 0),
        (215, 255, 95),
        (215, 255, 135),
        (215, 255, 175),
        (215, 255, 215),
        (215, 255, 255),
        (255, 0, 0),
        (255, 0, 95),
        (255, 0, 135),
        (255, 0, 175),
        (255, 0, 215),
        (255, 0, 255),
        (255, 95, 0),
        (255, 95, 95),
        (255, 95, 135),
        (255, 95, 175),
        (255, 95, 215),
        (255, 95, 255),
        (255, 135, 0),
        (255, 135, 95),
        (255, 135, 135),
        (255, 135, 175),
        (255, 135, 215),
        (255, 135, 255),
        (255, 175, 0),
        (255, 175, 95),
        (255, 175, 135),
        (255, 175, 175),
        (255, 175, 215),
        (255, 175, 255),
        (255, 215, 0),
        (255, 215, 95),
        (255, 215, 135),
        (255, 215, 175),
        (255, 215, 215),
        (255, 215, 255),
        (255, 255, 0),
        (255, 255, 95),
        (255, 255, 135),
        (255, 255, 175),
        (255, 255, 215),
        (255, 255, 255),
        (8, 8, 8),
        (18, 18, 18),
        (28, 28, 28),
        (38, 38, 38),
        (48, 48, 48),
        (58, 58, 58),
        (68, 68, 68),
        (78, 78, 78),
        (88, 88, 88),
        (98, 98, 98),
        (108, 108, 108),
        (118, 118, 118),
        (128, 128, 128),
        (138, 138, 138),
        (148, 148, 148),
        (158, 158, 158),
        (168, 168, 168),
        (178, 178, 178),
        (188, 188, 188),
        (198, 198, 198),
        (208, 208, 208),
        (218, 218, 218),
        (228, 228, 228),
        (238, 238, 238),
    ]

    public static func getNumber(system: ColorSystem, color: (UInt8, UInt8, UInt8)?) -> UInt8? {
        guard let color = color else {
            return nil
        }

        let palette: [(UInt8, UInt8, UInt8)]? =
            switch system {
            case .standard: ColorPalette.standard
            case .eightBit: ColorPalette.eightBit
            default: .none
            }

        guard let palette = palette else {
            return nil
        }

        var minDistance = Double.greatestFiniteMagnitude
        var closestColor: UInt8?
        for index in palette.indices {
            guard let paletteColor = palette[safe: index] else {
                continue
            }

            let distance = getDistance(first: color, second: paletteColor)
            if distance < minDistance {
                minDistance = distance
                closestColor = UInt8(index)
            }
        }

        return closestColor
    }

    /// Calculate the distance between two colors
    static func getDistance(first: (UInt8, UInt8, UInt8), second: (UInt8, UInt8, UInt8)) -> Double {
        let (r1, g1, b1) = first
        let (r2, g2, b2) = second

        let redMean = Double(Double(r1) + Double(r2)) / 2
        let red = Double(Double(r1) - Double(r2))
        let green = Double(Double(g1) - Double(g2))
        let blue = Double(Double(b1) - Double(b2))
        let a: Int = Int(((512 + redMean) * red * red)) >> 8
        let b: Int = Int(4 * green * green)
        let c: Int = Int(((767 + redMean) * blue * blue)) >> 8

        return sqrt(Double(a + b + c))
    }
}
