import Foundation

public protocol ConsoleProtocol {
    func write(_ renderable: Renderable)
}

public class Console: ConsoleProtocol {
    public let colors: ColorSystem

    public init() {
        self.colors = ColorSystemDetector.detect()
    }

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
