import Foundation

/// Represents something that can be 
/// rendered to the terminal
public protocol Renderable {
    func measure(options: RenderOptions, maxWidth: Int) -> Measurement
    func render(options: RenderOptions, maxWidth: Int) -> [Segment]
}

/// Represents options used when rendering
/// a ``Renderable`` instance
public struct RenderOptions {
}

/// Represents a measurement that 
/// has a minimum and maximum value
public struct Measurement {
    let min: Int
    let max: Int
}

/// Represents a segment
public struct Segment {
}
