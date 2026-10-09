import Testing

@testable import SpectreKit

struct MarkupTests {
    @Test func render() throws {
        // Given
        let markup = Markup("Hello [yellow]World[/]!")

        // When
        let result = markup.render(options: RenderOptions(supportsAnsi: true), maxWidth: 80)

        // Then
        #expect(result.count == 4)
        #expect(result[0] == Segment.text(content: "Hello", style: nil))
        #expect(result[1] == Segment.whitespace(content: " "))
        #expect(result[2] == Segment.text(content: "World", style: try! Style.parse("yellow")))
        #expect(result[3] == Segment.text(content: "!", style: nil))
    }
}
