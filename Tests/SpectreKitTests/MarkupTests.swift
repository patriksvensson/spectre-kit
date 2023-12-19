import XCTest

@testable import SpectreKit

final class MarkupTests: XCTestCase {
    func testRender() throws {
        // Given
        let markup = Markup(markup: "Hello [yellow]World[/]!")

        // When
        let result = markup.render(options: RenderOptions(), maxWidth: 80)

        // Then
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], Segment.text(content: "Hello", style: nil))
        XCTAssertEqual(result[1], Segment.whitespace(content: " "))
        XCTAssertEqual(result[2], Segment.text(content: "World", style: try! Style.parse("yellow")))
        XCTAssertEqual(result[3], Segment.text(content: "!", style: nil))
    }
}
