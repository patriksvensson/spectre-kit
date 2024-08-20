extension Character {
    func cellSize() -> Int {
        return Wcwidth.cellSize(self)
    }
}
