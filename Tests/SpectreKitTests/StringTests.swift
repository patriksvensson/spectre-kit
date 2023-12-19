import XCTest

@testable import SpectreKit

final class StringTests: XCTestCase {
    func testSplitWords() throws {
        // Given
        let result = "Hello World!".splitWords()
        // When
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], "Hello")
        XCTAssertEqual(result[1], " ")
        XCTAssertEqual(result[2], "World!")
    }

    func testSplitWordsAndThrowAwayWhitespace() throws {
        // Given
        let result = "Hello World!".splitWords(options: .removeEmpty)
        // When
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "Hello")
        XCTAssertEqual(result[1], "World!")
    }

    func testIfStringIsEmpty() {
        // With spaces
        XCTAssertEqual("   ".isWhitespace(), true)
        // With tabs
        XCTAssertEqual("        ".isWhitespace(), true)
        // With spaces and tabs
        XCTAssertEqual("      ".isWhitespace(), true)
        // With a letter
        XCTAssertEqual("  a".isWhitespace(), false)
    }
}
