import SpectreKit

public class TestTerminal: Terminal {
    public var stdout: String = ""
    public var stderr: String = ""

    public var width: Int = 80
    public var height: Int = 25
    public var type: TerminalType

    public init(width: Int = 80, height: Int = 25, emitAnsi: Bool = false) {
        self.width = width
        self.height = height
        self.type = emitAnsi ? TerminalType.tty : TerminalType.dumb
    }

    public func write(_ text: String) {
        stdout += text
    }

    public func writeError(_ text: String) {
        stderr += text
    }
}

public class TestConsole {
    private let terminal: TestTerminal
    private let console: Console

    public init(width: Int = 80, height: Int = 25, emitAnsi: Bool = false) {
        self.terminal = TestTerminal(width: width, height: height, emitAnsi: emitAnsi)
        self.console = Console(terminal: self.terminal)
    }

    public func write(_ renderable: any Renderable) -> String {
        self.console.write(renderable, lineBreak: false)
        return getStdOut()
    }

    public func getStdOut() -> String {
        return terminal.stdout
    }
}
