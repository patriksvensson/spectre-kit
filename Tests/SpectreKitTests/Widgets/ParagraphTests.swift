import Testing

@testable import SpectreKit

struct ParagraphTests {
    @Test func measurement() throws {
        // Given
        let paragraph = Paragraph("Hello World\nGoodbye World")
        // When
        let result = paragraph.measure(options: RenderOptions(supportsAnsi: true), maxWidth: 80)
        // Then
        #expect(result.min == 7, "min")
        #expect(result.max == 13, "max")
    }

    @Test func measurementOfUnicode() throws {
        // Given
        let paragraph = Paragraph("コ")
        // When
        let result = paragraph.measure(options: RenderOptions(supportsAnsi: true), maxWidth: 80)
        // Then
        #expect(result.min == 2, "min")
        #expect(result.max == 2, "max")
    }

    @Test func render() throws {
        // Given
        let paragraph = Paragraph("Hello World\nGoodbye World")

        // When
        let result = paragraph.render(options: RenderOptions(supportsAnsi: true), maxWidth: 80)

        // Then
        #expect(result.count == 7)
        #expect(result[0] == Segment.text(content: "Hello", style: nil))
        #expect(result[1] == Segment.whitespace(content: " "))
        #expect(result[2] == Segment.text(content: "World", style: nil))
        #expect(result[3] == Segment.lineBreak)
        #expect(result[4] == Segment.text(content: "Goodbye", style: nil))
        #expect(result[5] == Segment.whitespace(content: " "))
        #expect(result[6] == Segment.text(content: "World", style: nil))
    }
}
