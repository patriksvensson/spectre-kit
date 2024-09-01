/// Represents padding.
public struct Padding: Equatable, Hashable {
    /// Gets the left padding.
    public let left: Int

    /// Gets the top padding.
    public let top: Int

    /// Gets the right padding.
    public let right: Int

    /// Gets the bottom padding.
    public let bottom: Int

    /// Initializes a new instance of the ``Padding`` struct
    /// - Parameter size: The padding for all sides.
    public init(_ size: Int) {
        self.init(left: size, top: size, right: size, bottom: size)
    }

    /// Initializes a new instance of the ``Padding`` struct
    /// - Parameter horizontal: The left and right padding.
    /// - Parameter vertical: The top and bottom padding.
    public init(horizontal: Int, vertical: Int) {
        self.init(left: horizontal, top: vertical, right: horizontal, bottom: vertical)
    }

    /// Initializes a new instance of the ``Padding`` struct
    /// - Parameter left: The left padding.
    /// - Parameter top: The top padding.
    /// - Parameter right: The right padding.
    /// - Parameter bottom: The bottom padding.
    public init(left: Int, top: Int, right: Int, bottom: Int) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }

    /// Gets the padding width.
    /// - Returns: The padding width.
    public func getWidth() -> Int {
        left + right
    }

    /// Gets the padding height.
    /// - Returns: The padding height.
    public func getHeight() -> Int {
        top + bottom
    }
}

extension Padding? {
    func getSafeLeftPadding() -> Int {
        return self?.left ?? 0
    }

    func getSafeRightPadding() -> Int {
        return self?.right ?? 0
    }

    func getSafeTopPadding() -> Int {
        return self?.top ?? 0
    }

    func getSafeBottomPadding() -> Int {
        return self?.bottom ?? 0
    }
}
