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

    public let type: TerminalType

    public var width: Int {
        if let columns = Environment.getEnvironmentVar("COLUMNS"),
            let width = Int(columns)
        {
            return width
        }
        
        // Try determining using ioctl.
        // Following code does not compile on ppc64le well. TIOCGWINSZ is
        // defined in system ioctl.h file which needs to be used. This is
        // a temporary arrangement and needs to be fixed.
#if !arch(powerpc64le)
        var ws = winsize()
#if os(OpenBSD)
        let tiocgwinsz = 0x40087468
        let err = ioctl(1, UInt(tiocgwinsz), &ws)
#else
        let err = ioctl(1, UInt(TIOCGWINSZ), &ws)
#endif
        if err == 0 {
            return Int(ws.ws_col)
        }
#endif
        return 80
    }

    public var height: Int {
        if let lines = Environment.getEnvironmentVar("LINES"),
            let height = Int(lines)
        {
            return height
        }
        
        // Try determining using ioctl.
        // Following code does not compile on ppc64le well. TIOCGWINSZ is
        // defined in system ioctl.h file which needs to be used. This is
        // a temporary arrangement and needs to be fixed.
#if !arch(powerpc64le)
        var ws = winsize()
#if os(OpenBSD)
        let tiocgwinsz = 0x40087468
        let err = ioctl(1, UInt(tiocgwinsz), &ws)
#else
        let err = ioctl(1, UInt(TIOCGWINSZ), &ws)
#endif
        if err == 0 {
            return Int(ws.ws_row)
        }
#endif
        return 24
    }

    public init() {
        stdout = FileHandleStream(handle: FileHandle.standardOutput)
        stderr = FileHandleStream(handle: FileHandle.standardError)

        if let t = ProcessInfo.processInfo.environment["TERM"], t == "dumb" {
            type = .dumb
        } else {
            let isTTY = isatty(FileHandle.standardOutput.fileDescriptor) == 1
            type = isTTY ? .tty : .file
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
