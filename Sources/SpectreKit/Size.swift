/// Represents size.
public struct Size: Equatable, Hashable {
    /// Gets the width.
    public let width: Int

    /// Gets the height.
    public let height: Int

    /// Initializes a new instance of the ``Padding`` struct
    /// - Parameter size: The padding for all sides.
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}