extension String {

    func cellCount() -> Int {
        return Wcwidth.cellCount(self)
    }

    func substring(end: Int) -> String {
        self.substring(to: self.index(self.startIndex, offsetBy: end))
    }

    func isWhitespace() -> Bool {
        for character in self {
            if !character.isWhitespace {
                return false
            }
        }
        return true
    }

    func normalizeNewLines() -> String {
        return self.replacingOccurrences(of: "\r\n", with: "\n")
    }

    var cellCount: Int {
        var count = 0
        for ch in self {
            count += self.count
        }
        return count
    }
    
    func splitLines() -> [String] {
        return
            self
            .normalizeNewLines()
            .components(separatedBy: "\n")
    }

    func splitWords(options: SplitOptions = SplitOptions.none) -> [String] {
        func read(peekable: inout PeekableIterator<String.Iterator>, criteria: (Character) -> Bool)
            -> String
        {
            var accumulator: [Character] = []
            while !peekable.reachedEnd {
                guard let current = peekable.peek() else {
                    break
                }

                if !criteria(current) {
                    break
                }

                accumulator.append(current)
                _ = peekable.next()  // Consume
            }
            return String(accumulator)
        }

        func isWhitespace(character: Character) -> Bool {
            character.isWhitespace
        }

        func isNotWhitespace(character: Character) -> Bool {
            !character.isWhitespace
        }

        var result: [String] = []
        var buffer = self.makePeekable()
        while !buffer.reachedEnd {
            guard let current = buffer.peek() else {
                break
            }

            if current.isWhitespace {
                // Parse all whitespace
                let part = read(peekable: &buffer, criteria: isWhitespace)
                if options != .removeEmpty {
                    result.append(part)
                }
            } else {
                // Parse until we encounter whitespace
                let part = read(peekable: &buffer, criteria: isNotWhitespace)
                result.append(part)
            }
        }

        return result
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }

    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }

    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }

    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        self[index(startIndex, offsetBy: range.lowerBound)...]
    }

    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        self[...index(startIndex, offsetBy: range.upperBound)]
    }

    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        self[..<index(startIndex, offsetBy: range.upperBound)]
    }
}

enum SplitOptions {
    case none
    case removeEmpty
}
