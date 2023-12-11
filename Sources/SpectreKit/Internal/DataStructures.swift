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
        if !list.isEmpty {
            return list[0]
        } else {
            return nil
        }
    }
}

