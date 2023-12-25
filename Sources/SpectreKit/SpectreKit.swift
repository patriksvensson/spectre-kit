import Foundation

/// Represents something that can render ``Renderable`` objects.
public protocol Renderer {
    /// Writes a ``Renderable``to the console.
    func write(_ renderable: Renderable)
}

/// A console capable of rendering ``Renderable``objects to `stdout`.
public class Console: Renderer {
    public let colors: ColorSystem

    public init() {
        self.colors = ColorSystemDetector.detect()
    }

    /// Writes a ``Renderable`` to stdout.
    public func write(_ renderable: Renderable) {
        print(
            AnsiBuilder.build(
                options: RenderOptions(),
                colors: colors,
                renderable: renderable,
                maxWidth: getWidth()))
    }

    func getWidth() -> Int {
        // This is of course not OK, but until we have a proper
        // terminal abstraction, this will have to be OK.
        if let columns = ProcessInfo.processInfo.environment["COLUMNS"], let width = Int(columns) {
            return width
        }

        return 80
    }
}
