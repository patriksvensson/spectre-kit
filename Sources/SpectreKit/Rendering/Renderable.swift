import Foundation

///////////////////////////////////////////////////////////////////////////////
// Renderable

/// Represents something that can be  rendered to the terminal.
public protocol Renderable {
    /// Measures the object.
    /// - Parameters:
    ///   - options: The render options.
    ///   - maxWidth: The maximum allowed width.
    /// - Returns: The minimum and maximum width of the object.
    func measure(options: RenderOptions, maxWidth: Int) -> Measurement

    /// Renders the object into segments.
    /// - Parameters:
    ///   - options: The render options.
    ///   - maxWidth: The maximum allowed width.
    /// - Returns: An array of segments.
    func render(options: RenderOptions, maxWidth: Int) -> [Segment]
}

///////////////////////////////////////////////////////////////////////////////
// RenderOptions

/// Options used when rendering a ``Renderable`` instance.
public struct RenderOptions {
}

///////////////////////////////////////////////////////////////////////////////
// Measurement

/// A measurement that has a minimum and maximum value.
public struct Measurement: Equatable {
    /// The minimum width
    public let min: Int
    /// The maximum width
    public let max: Int
}
