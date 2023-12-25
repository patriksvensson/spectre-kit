// -----------------------------------------------------------------------------
// AnsiBuilder

struct AnsiBuilder {
    private static let esc = "\u{001B}"
    private static let csi = esc + "["

    public static func buildAnsi(
        options: RenderOptions,
        colors: ColorSystem,
        renderable: Renderable,
        maxWidth: Int
    ) -> String {
        var builder = String()
        for segment in renderable.render(options: options, maxWidth: maxWidth) {
            // Get the style and the text
            let style = segment.getStyle()
            guard let text = segment.getText() else {
                continue
            }

            if segment.isControlCode {
                builder.append(text)
                continue
            }

            let parts = text.splitLines()
            for (_, _, isLast, part) in parts.makeSequenceIterator() {
                if !part.isEmpty {
                    builder.append(buildAnsiFromSegment(colors: colors, text: text, style: style))
                }

                if !isLast {
                    builder.append("\n")
                }
            }
        }

        return builder
    }

    private static func buildAnsiFromSegment(
        colors: ColorSystem,
        text: String,
        style: Style
    ) -> String {
        var codes = AnsiDecorationBuilder.getAnsi(decoration: style.decoration)

        if style.foreground != .none {
            codes += AnsiColorBuilder.getAnsi(
                colors: colors,
                color: style.foreground,
                isForeground: true)
        }

        if style.background != .none {
            codes += AnsiColorBuilder.getAnsi(
                colors: colors,
                color: style.background,
                isForeground: false)
        }

        if codes.count == 0 {
            return text
        }

        let ansi = codes.count > 0 ? "\(sgr(codes))\(text)\(sgr([0]))" : text
        return ansi
    }

    private static func sgr(_ codes: [UInt8]) -> String {
        let res = codes.map { String($0) }.joined(separator: ";")
        return "\(csi)\(res)m"
    }
}

// -----------------------------------------------------------------------------
// AnsiColorBuilder

fileprivate struct AnsiColorBuilder {
    public static func getAnsi(colors: ColorSystem, color: Color?, isForeground: Bool) -> [UInt8] {
        guard let color else {
            return []
        }

        return switch colors {
        case .noColor:
            []
        case .standard:
            getStandard(color: color, isForeground: isForeground)
        case .eightBit:
            getEightBit(color: color, isForeground: isForeground)
        case .trueColor:
            getTwentyFourBit(color: color, isForeground: isForeground)
        }
    }

    private static func getStandard(color: Color, isForeground: Bool) -> [UInt8] {
        switch color {
        case .default:
            return []
        case let .number(number):
            guard number < 16 else {
                fatalError("Invalid range for 4-bit color")
            }
            let mod: UInt8 = number < 8 ? (isForeground ? 30 : 40) : (isForeground ? 82 : 92)
            return [number + mod]
        case let .rgb(r, g, b):
            let closest = ColorPalette.getNumber(system: ColorSystem.standard, color: (r, g, b))
            guard let closest else {
                fatalError("Could not retrieve index from palette")
            }

            let mod: UInt8 = closest < 8 ? (isForeground ? 30 : 40) : (isForeground ? 82 : 92)
            return [closest + mod]
        }
    }

    private static func getEightBit(color: Color, isForeground: Bool) -> [UInt8] {
        switch color {
        case .default:
            return []
        case let .number(number):
            let mod: UInt8 = isForeground ? 38 : 48
            return [mod, 5, number]
        case let .rgb(r, g, b):
            let closest = ColorPalette.getNumber(system: ColorSystem.eightBit, color: (r, g, b))
            guard let closest else {
                fatalError("Could not retrieve index from palette")
            }

            let mod: UInt8 = isForeground ? 38 : 48
            return [mod, 5, closest]
        }
    }

    private static func getTwentyFourBit(color: Color, isForeground: Bool) -> [UInt8] {
        switch color {
        case .default:
            return []
        case .number:
            return getEightBit(color: color, isForeground: isForeground)
        case let .rgb(r, g, b):
            let mod: UInt8 = isForeground ? 38 : 48
            return [mod, 2, r, g, b]
        }
    }
}

// -----------------------------------------------------------------------------
// AnsiDecorationBuilder

fileprivate struct AnsiDecorationBuilder {
    public static func getAnsi(decoration: Decoration) -> [UInt8] {
        var result: [UInt8] = []

        if decoration.contains(.bold) {
            result.append(1)
        }
        if decoration.contains(.dim) {
            result.append(2)
        }
        if decoration.contains(.italic) {
            result.append(3)
        }
        if decoration.contains(.underline) {
            result.append(4)
        }
        if decoration.contains(.slowBlink) {
            result.append(5)
        }
        if decoration.contains(.rapidBlink) {
            result.append(6)
        }
        if decoration.contains(.invert) {
            result.append(7)
        }
        if decoration.contains(.conceal) {
            result.append(8)
        }

        return result
    }
}
