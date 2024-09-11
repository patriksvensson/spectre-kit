import Foundation

extension Sequence {
    func makeSequenceIterator() -> SequenceIterator<Self.Iterator> {
        return .init(iterator: makeIterator())
    }

    func makePeekable() -> PeekableIterator<Self.Iterator> {
        return .init(iterator: makeIterator())
    }

    func firstOrDefault(_ fn: (Element) -> Bool) -> Element? {
        for item in self {
            if fn(item) {
                return item
            }
        }
        return nil
    }

    func any(_ fn: (Element) -> Bool) -> Bool {
        return filter(fn).count > 0
    }
}

extension Sequence where Element: Numeric {
    func sum() -> Element { return reduce(0, +) }
}
