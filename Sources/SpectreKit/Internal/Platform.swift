// Parts of this file borrowed from 
// https://github.com/swiftlang/swift-tools-support-core/blob/main/Sources/TSCBasic/TerminalController.swift
import Foundation

#if os(Windows)
import WinSDK
#endif

protocol Platform {
    func getTerminalType() -> TerminalType
    func getTerminalSize() -> Size?
}

#if !os(Windows)
class PosixPlatform : Platform {
    func getTerminalType() -> TerminalType {
        let isTTY = isatty(FileHandle.standardOutput.fileDescriptor) == 1
        return isTTY ? .tty : .file
    }

    func getTerminalSize() -> Size? {
        // Try determining using ioctl.
        // Following code does not compile on ppc64le well. TIOCGWINSZ is
        // defined in system ioctl.h file which needs to be used. This is
        // a temporary arrangement and needs to be fixed.
        #if !arch(powerpc64le)
            var ws = winsize()
            #if os(OpenBSD)
                let tiocgwinsz = 0x4008_7468
                let err = ioctl(1, UInt(tiocgwinsz), &ws)
            #else
                let err = ioctl(1, UInt(TIOCGWINSZ), &ws)
            #endif

            if err == 0 && ws.ws_col != 0 {
                return Size(
                    width: Int(ws.ws_col),
                    height: Int(ws.ws_row))
            }
        #endif

        return nil
    }
}
#endif

#if os(Windows)
class WindowsPlatform: Platform {
    var handle: HANDLE

    init() {
        self.handle = GetStdHandle(STD_OUTPUT_HANDLE)
    }

    func getTerminalType() -> TerminalType {
        var sbi = CONSOLE_SCREEN_BUFFER_INFO()
        if GetConsoleScreenBufferInfo(handle, &sbi) {
            return .tty
        }
        return .file
    }

    func getTerminalSize() -> Size? {
        var sbi = CONSOLE_SCREEN_BUFFER_INFO()
        if GetConsoleScreenBufferInfo(handle, &sbi) {
            return Size(
                width: Int(sbi.dwSize.X),
                height: Int(sbi.dwSize.Y))
        }
        return nil
    }
}
#endif