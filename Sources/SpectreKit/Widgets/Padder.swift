public class Padder: Renderable, Paddable, Expandable {
    private let child: Renderable

    public var padding: Padding?
    public var expand: Bool = false

    public init(_ child: Renderable, _ padding: Padding? = nil) {
        self.child = child
        self.padding = padding
    }

    public func measure(options: RenderOptions, maxWidth: Int) -> Measurement {
        let paddingWidth = padding?.getWidth() ?? 0
        let measurement = self.child.measure(options: options, maxWidth: maxWidth - paddingWidth)

        return Measurement(
            min: measurement.min + paddingWidth,
            max: measurement.max + paddingWidth)
    }

    public func render(options: RenderOptions, maxWidth: Int) -> [Segment] {
        let paddingWidth = self.padding?.getWidth() ?? 0
        var childWidth = maxWidth - paddingWidth

        if !self.expand {
            let measurement = self.child.measure(
                options: options, maxWidth: maxWidth - paddingWidth)
            childWidth = measurement.max
        }

        var width = childWidth + paddingWidth
        var result: [Segment] = []

        if width > maxWidth {
            width = maxWidth
        }

        // Top padding
        for _ in 0..<(self.padding?.top ?? 0) {
            result.append(Segment.padding(count: width))
            result.append(Segment.lineBreak)
        }

        let child = self.child.render(options: options, maxWidth: maxWidth - paddingWidth)
        for line in Segment.splitLines(segments: child) {
            // Left padding
            if let left = padding?.left {
                if left > 0 {
                    result.append(Segment.padding(count: left))
                }
            }

            result.append(contentsOf: line.segments)

            // Right padding
            if let right = padding?.right {
                if right > 0 {
                    result.append(Segment.padding(count: right))
                }
            }

            // Missing space on right side?
            let lineWidth = line.cellCount
            let diff = width - lineWidth - (self.padding?.left ?? 0) - (self.padding?.right ?? 0)
            if diff > 0 {
                result.append(Segment.padding(count: diff))
            }

            result.append(Segment.lineBreak)
        }

        // Bottom padding
        for _ in 0..<(self.padding?.bottom ?? 0) {
            result.append(Segment.padding(count: width))
            result.append(Segment.lineBreak)
        }

        return result
    }
}
