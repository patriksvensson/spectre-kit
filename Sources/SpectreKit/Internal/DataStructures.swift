///////////////////////////////////////////////////////////////////////////////
// Queue

struct Queue<T> {
    var list = [T]()

    public var isEmpty: Bool {
        return list.isEmpty
    }

    public var count: Int {
        return list.count
    }

    public mutating func enqueue(_ element: T) {
        list.append(element)
    }

    public mutating func dequeue() -> T? {
        if !list.isEmpty {
            return list.removeFirst()
        } else {
            return nil
        }
    }

    public func peek() -> T? {
        return list.first
    }
}

extension Queue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        list = elements
    }
}

extension Queue: Sequence {
    typealias Iterator = IndexingIterator<[T]>

    func makeIterator() -> Queue.Iterator {
        return list.makeIterator()
    }
}

///////////////////////////////////////////////////////////////////////////////
// Stack

struct Stack<T> {
    var list = [T]()

    public var isEmpty: Bool {
        return list.isEmpty
    }

    public var count: Int {
        return list.count
    }

    public mutating func push(_ element: T) {
        list.append(element)
    }

    func peek() -> T? {
        return list.last
    }

    @discardableResult
    public mutating func pop() -> T? {
        if !list.isEmpty {
            return list.removeLast()
        } else {
            return nil
        }
    }
}

extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        list = elements
    }
}

extension Stack: Sequence {
    typealias Iterator = IndexingIterator<[T]>

    func makeIterator() -> Stack.Iterator {
        return list.makeIterator()
    }
}
