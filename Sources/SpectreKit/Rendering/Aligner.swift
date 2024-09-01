class Aligner {
    public static func align(_ segments: inout [Segment], alignment: Justify?, maxWidth: Int) {
        guard alignment != nil else {
            return
        }

        let width = segments.cellCount
        if width >= maxWidth {
            return
        }

        switch alignment.unsafelyUnwrapped {
        case .right:
            let diff = maxWidth - width
            segments.insert(Segment.padding(count: diff), at: 0)
        case .center:
            let diff = (maxWidth - width) / 2
            segments.insert(Segment.padding(count: diff), at: 0)

            segments.append(Segment.padding(count: diff))
            let remainder = (maxWidth - width) % 2
            if remainder != 0 {
                segments.append(Segment.padding(count: remainder))
            }
        case .left:
            break
        }
    }
}
