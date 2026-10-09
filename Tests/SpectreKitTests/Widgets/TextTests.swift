import Testing

@testable import SpectreKit

struct TextTests {
    private static var returnCorrectNumberOfLinesTests = [
        ("Hello", 1),
        ("Hello\nWorld", 2),
    ]

    @Test(arguments: returnCorrectNumberOfLinesTests)
    func shouldReturnCorrectNumberOfLines(_ test: (String, Int)) {
        let (input, expected) = test
        // Given
        let text = Text(input)

        // When
        let result = text.lineCount

        // Then
        #expect(expected == result)
    }

    @Test func longestWordIsMinimumWidth() {
        // Given
        let text = Text("Foo Bar Baz\nQux\nLol mobile")

        // When
        let result = text.measure(
            options: RenderOptions.init(supportsAnsi: false, supportsUnicode: true),
            maxWidth: 80)

        // Then
        #expect(6 == result.min)
    }

    @Test func longestLineIsMaximumWidth() {
        // Given
        let text = Text("Foo Bar Baz\nQux\nLol mobile")

        // When
        let result = text.measure(
            options: RenderOptions.init(supportsAnsi: false, supportsUnicode: true),
            maxWidth: 80)

        // Then
        #expect(11 == result.max)
    }

    @Test func shouldWriteLineBreaks() {
        // Given
        let console = TestConsole()
        let text = Text("Hello\n\nWorld\n\n")

        // When
        let result = console.write(text)

        // Then
        #expect("Hello\n\nWorld\n\n" == result)
    }

    @Test func shouldNormalizeLineBreaksWithCarriageReturn() {
        // Given
        let console = TestConsole()
        let text = Text("Hello\r\n\r\nWorld\r\n\r\n")

        // When
        let result = console.write(text)

        // Then
        #expect("Hello\n\nWorld\n\n" == result)
    }

    @Test func shouldSplitUnstyledTextToNewLinesIfWidthExceedsConsoleWidth() {
        // Given
        let console = TestConsole(width: 10)
        let text = Text("Hello Sweet Nice World")

        // When
        let result = console.write(text)

        // Then
        #expect("Hello \nSweet Nice\nWorld" == result)
    }

    @Test func shouldFoldText() {
        // Given
        let console = TestConsole(width: 14)
        let text = Text("foo pneumonoultramicroscopicsilicovolcanoconiosis bar qux")
        text.overflow = Overflow.fold

        // When
        let result = console.write(text)

        // Then
        #expect("foo \npneumonoultram\nicroscopicsili\ncovolcanoconio\nsis bar qux" == result)
    }

    @Test func shouldCropText() {
        // Given
        let console = TestConsole(width: 14)
        let text = Text("foo pneumonoultramicroscopicsilicovolcanoconiosis bar qux")
        text.overflow = Overflow.crop

        // When
        let result = console.write(text)

        // Then
        #expect("foo \npneumonoultram\nbar qux" == result)
    }

    @Test func shouldOverflowTextWithEllipsis() {
        // Given
        let console = TestConsole(width: 14)
        let text = Text("foo pneumonoultramicroscopicsilicovolcanoconiosis bar qux")
        text.overflow = Overflow.ellipsis

        // When
        let result = console.write(text)

        // Then
        #expect("foo \npneumonoultra…\nbar qux" == result)
    }
}
