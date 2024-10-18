import Foundation

// -----------------------------------------------------------------------------
// Terminal

/// Represents a terminal.
public protocol Terminal {
    /// The width of the terminal
    var width: Int { get }

    /// The height of the terminal.
    var height: Int { get }

    /// Gets the terminal type.
    var type: TerminalType { get }

    /// Writes the specified text to `STDOUT`.
    func write(_ text: String)

    /// Writes the specified text to `STDERR`.
    func writeError(_ text: String)
}

extension Terminal {
    var supportsAnsi: Bool {
        return self.type == .tty
    }
    var supportsUnicode: Bool {
        return self.type == .tty
    }
}

// -----------------------------------------------------------------------------
// TerminalType

/// Represents a terminal type
public enum TerminalType {
    case dumb
    case tty
    case file
}

// -----------------------------------------------------------------------------
// DefaultTerminal

class DefaultTerminal: Terminal {
    var stdout: TextOutputStream
    var stderr: TextOutputStream
    let platform: Platform

    public let type: TerminalType

    public var width: Int {
        if let columns = Environment.getEnvironmentVar("COLUMNS"),
            let width = Int(columns)
        {
            return width
        }

        if let size = self.platform.getTerminalSize() {
            return size.width
        }

        return 80
    }

    public var height: Int {
        if let lines = Environment.getEnvironmentVar("LINES"),
            let height = Int(lines)
        {
            return height
        }

        if let size = self.platform.getTerminalSize() {
            return size.height
        }

        return 24
    }

    public init() {
        self.stdout = FileHandleStream(handle: FileHandle.standardOutput)
        self.stderr = FileHandleStream(handle: FileHandle.standardError)

        #if !os(Windows)
            self.platform = PosixPlatform()
        #else
            self.platform = WindowsPlatform()
        #endif

        if let type = ProcessInfo.processInfo.environment["TERM"], type == "dumb" {
            self.type = .dumb
        } else {
            self.type = self.platform.getTerminalType()
        }
    }

    public func write(_ text: String) {
        self.stdout.write(text)
    }

    public func writeError(_ text: String) {
        self.stderr.write(text)
    }
}

class FileHandleStream: TextOutputStream {
    let handle: FileHandle

    init(handle: FileHandle) {
        self.handle = handle
    }

    func write(_ string: String) {
        let data = string.data(using: .utf8)
        if let data = data {
            self.handle.write(data)
        }
    }
}
