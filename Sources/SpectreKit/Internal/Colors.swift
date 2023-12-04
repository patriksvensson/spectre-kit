import Foundation

struct ColorTable {
    public static func getColor(number: UInt8) -> Color {
        ColorPalette.eightBit[Int(number)]
    }
    
    public static func getColor(name: String) -> Color? {
        if let number = ColorTable.nameLookup[name] {
            return ColorPalette.eightBit[number]
        }
        return nil
    }
}

struct ColorPalette {
    public static func getExactOrClosest(system: ColorSystem, color: Color) -> Color? {
        let exact = getExact(system: system, color: color)
        return exact ?? getClosest(system: system, color: color)
    }
 
    public static func getExact(system: ColorSystem, color: Color) -> Color? {
        if system == .trueColor {
            return color
        }
        
        let palette: [Color]? = switch system {
            case .threeBit: ColorPalette.threeBit
            case .fourBit: ColorPalette.fourBit
            case .eightBit: ColorPalette.eightBit
            default: nil
        }
        
        if let palette {
            if let found = palette.firstOrDefault({ $0 == color }) {
                return found
            }
        }
        
        return nil
    }
    
    public static func getClosest(system: ColorSystem, color: Color) -> Color? {
        if system == .trueColor {
            return color
        }
        
        let palette: [Color]? = switch system {
            case .threeBit: ColorPalette.threeBit
            case .fourBit: ColorPalette.fourBit
            case .eightBit: ColorPalette.eightBit
            default: nil
        }
        
        if let palette {
            var min: Double = Double.greatestFiniteMagnitude
            var current: Color? = .none
            for paletteColor in palette {
                let distance = paletteColor.getDistance(other: color)
                if distance < min {
                    min = distance
                    current = paletteColor
                }
            }
            
            return current
        }
        
        return nil
    }
}
