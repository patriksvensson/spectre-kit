import Testing

@testable import SpectreKit

struct StringTests {
    @Test func splitWords() throws {
        // Given
        let result = "Hello World!".splitWords()
        // When
        #expect(result.count == 3)
        #expect(result[0] == "Hello")
        #expect(result[1] == " ")
        #expect(result[2] == "World!")
    }

    @Test func splitWordsAndThrowAwayWhitespace() throws {
        // Given
        let result = "Hello World!".splitWords(options: .removeEmpty)
        // When
        #expect(result.count == 2)
        #expect(result[0] == "Hello")
        #expect(result[1] == "World!")
    }

    @Test func isStringEmpty() {
        // With spaces
        #expect("   ".isWhitespace())
        // With tabs
        #expect("        ".isWhitespace())
        // With spaces and tabs
        #expect("      ".isWhitespace())
        // With a letter
        #expect(!"  a".isWhitespace())
    }

    @Test func measureUnicode() throws {
        // Given
        let paragraph = "コ"
        // When
        let result = paragraph.cellCount()
        // Then
        #expect(result == 2)
    }
}
