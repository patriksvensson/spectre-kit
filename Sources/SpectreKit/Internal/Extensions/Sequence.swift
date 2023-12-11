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
}
