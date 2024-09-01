import XCTest

@testable import SpectreKit

final class TextTests: XCTestCase {
    func test_ShouldReturnCorrectNumberOfLines() {
        let testData = [
            ("Hello", 1),
            ("Hello\nWorld", 2),
        ]

        for (input, expected) in testData {
            XCTContext.runActivity(named: "Number of lines: \(expected)") { _ in
                // Given
                let text = Text(input)

                // When
                let result = text.lineCount

                // Then
                XCTAssertEqual(expected, result)
            }
        }
    }

    func test_LongestWordIsMinimumWidth() {
        // Given
        let text = Text("Foo Bar Baz\nQux\nLol mobile")

        // When
        let result = text.measure(
            options: RenderOptions.init(supportsAnsi: false, supportsUnicode: true),
            maxWidth: 80)

        // Then
        XCTAssertEqual(6, result.min)
    }

    func test_LongestLineIsMaximumWidth() {
        // Given
        let text = Text("Foo Bar Baz\nQux\nLol mobile")

        // When
        let result = text.measure(
            options: RenderOptions.init(supportsAnsi: false, supportsUnicode: true),
            maxWidth: 80)

        // Then
        XCTAssertEqual(11, result.max)
    }

    func test_ShouldWriteLineBreaks() {
        // Given
        let console = TestConsole()
        let text = Text("Hello\n\nWorld\n\n")

        // When
        let result = console.write(text)

        // Then
        XCTAssertEqual("Hello\n\nWorld\n\n", result)
    }

    func test_ShouldNormalizeLineBreaksWithCarriageReturn() {
        // Given
        let console = TestConsole()
        let text = Text("Hello\r\n\r\nWorld\r\n\r\n")

        // When
        let result = console.write(text)

        // Then
        XCTAssertEqual("Hello\n\nWorld\n\n", result)
    }

    func test_ShouldSplitUnstyledTextToNewLinesIfWidthExceedsConsoleWidth() {
        // Given
        let console = TestConsole(width: 10)
        let text = Text("Hello Sweet Nice World")

        // When
        let result = console.write(text)

        // Then
        XCTAssertEqual("Hello \nSweet Nice\nWorld", result)
    }

    func test_ShouldFoldText() {
        // Given
        let console = TestConsole(width: 14)
        let text = Text("foo pneumonoultramicroscopicsilicovolcanoconiosis bar qux")
        text.overflow = Overflow.fold

        // When
        let result = console.write(text)

        // Then
        XCTAssertEqual("foo \npneumonoultram\nicroscopicsili\ncovolcanoconio\nsis bar qux", result)
    }

    func test_ShouldCropText() {
        // Given
        let console = TestConsole(width: 14)
        let text = Text("foo pneumonoultramicroscopicsilicovolcanoconiosis bar qux")
        text.overflow = Overflow.crop

        // When
        let result = console.write(text)

        // Then
        XCTAssertEqual("foo \npneumonoultram\nbar qux", result)
    }

    func test_ShouldOverflowTextWithEllipsis() {
        // Given
        let console = TestConsole(width: 14)
        let text = Text("foo pneumonoultramicroscopicsilicovolcanoconiosis bar qux")
        text.overflow = Overflow.ellipsis

        // When
        let result = console.write(text)

        // Then
        XCTAssertEqual("foo \npneumonoultra…\nbar qux", result)
    }
}
