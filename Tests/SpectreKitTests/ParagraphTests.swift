import XCTest

@testable import SpectreKit

final class ParagraphTests: XCTestCase {
    func testMeasurement() throws {
        // Given
        let paragraph = Paragraph("Hello World\nGoodbye World")
        // When
        let result = paragraph.measure(options: RenderOptions(supportsAnsi: true), maxWidth: 80)
        // Then
        XCTAssertEqual(result.min, 7, "min")
        XCTAssertEqual(result.max, 13, "max")
    }

    func testMeasurementOfUnicode() throws {
        // Given
        let paragraph = Paragraph("コ")
        // When
        let result = paragraph.measure(options: RenderOptions(supportsAnsi: true), maxWidth: 80)
        // Then
        XCTAssertEqual(result.min, 2, "min")
        XCTAssertEqual(result.max, 2, "max")
    }

    func testRender() throws {
        // Given
        let paragraph = Paragraph("Hello World\nGoodbye World")

        // When
        let result = paragraph.render(options: RenderOptions(supportsAnsi: true), maxWidth: 80)

        // Then
        XCTAssertEqual(result.count, 7)
        XCTAssertEqual(result[0], Segment.text(content: "Hello", style: nil))
        XCTAssertEqual(result[1], Segment.whitespace(content: " "))
        XCTAssertEqual(result[2], Segment.text(content: "World", style: nil))
        XCTAssertEqual(result[3], Segment.lineBreak)
        XCTAssertEqual(result[4], Segment.text(content: "Goodbye", style: nil))
        XCTAssertEqual(result[5], Segment.whitespace(content: " "))
        XCTAssertEqual(result[6], Segment.text(content: "World", style: nil))
    }
}
