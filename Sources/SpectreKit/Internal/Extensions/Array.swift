extension Array {
    func zip<T>(_ other: [T]) -> [(Element, T)] {
        var result: [(Element, T)] = []
        let count = Swift.min(self.count, other.count)
        for index in 0..<count {
            result.append((self[index], other[index]))
        }
        return result
    }

    func zip<TSecond, TThird>(_ second: [TSecond], _ third: [TThird])
        -> [(Element, TSecond, TThird)]
    {
        return zip(second) { a, b in (a, b) }
            .zip(third) { a, b in (a.0, a.1, b) }
    }

    func zip<T, TResult>(_ other: [T], _ fn: (Element, T) -> TResult) -> [TResult] {
        var result: [TResult] = []
        let count = Swift.min(self.count, other.count)
        for index in 0..<count {
            result.append(fn(self[index], other[index]))
        }
        return result
    }

    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}
