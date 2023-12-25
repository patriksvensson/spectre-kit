// -----------------------------------------------------------------------------
// SequenceIterator

struct SequenceIterator<T: IteratorProtocol>: IteratorProtocol, Sequence {
    public typealias Element = (index: Int, isFirst: Bool, isLast: Bool, item: T.Element)

    private var iterator: T
    private var current: T.Element?
    private var index = 0
    private var isFirst = true

    public init(iterator: T) {
        self.iterator = iterator
        self.current = self.iterator.next()
    }

    public mutating func next() -> (index: Int, isFirst: Bool, isLast: Bool, item: T.Element)? {
        guard let current else {
            return nil
        }

        let next = iterator.next()

        defer {
            self.current = next
            self.isFirst = false
            self.index += 1
        }

        return (
            index: self.index,
            isFirst: self.isFirst,
            isLast: next == nil,
            item: current
        )
    }
}

// -----------------------------------------------------------------------------
// PeekableIterator

struct PeekableIterator<T: IteratorProtocol>: IteratorProtocol, Sequence {
    public typealias Element = T.Element

    private var iterator: T
    private var current: T.Element?

    var reachedEnd: Bool {
        self.current == nil
    }

    public init(iterator: T) {
        self.iterator = iterator
        self.current = self.iterator.next()
    }

    public mutating func peek() -> T.Element? {
        self.current
    }

    public mutating func next() -> T.Element? {
        guard let current else {
            return nil
        }

        let next = iterator.next()
        defer {
            self.current = next
        }

        return current
    }
}
