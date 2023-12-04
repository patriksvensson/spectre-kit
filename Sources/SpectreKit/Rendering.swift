import Foundation

/// Represents something that can be  rendered to the terminal
public protocol Renderable {
    /// Measures the renderable object.
    /// - Parameters:
    ///   - options: The render options.
    ///   - maxWidth: The maximum allowed width.
    /// - Returns: The minimum and maximum width of the object.
    func measure(options: RenderOptions, maxWidth: Int) -> Measurement
    
    func render(options: RenderOptions, maxWidth: Int) -> [Segment]
}

/// Options used when rendering a ``Renderable`` instance
public struct RenderOptions {
}

/// A measurement that has a minimum and maximum value
public struct Measurement: Equatable {
    /// The minimum width
    public let min: Int
    /// The maximum width
    public let max: Int
}

/// Represents a renderable segment
public struct Segment {
}
