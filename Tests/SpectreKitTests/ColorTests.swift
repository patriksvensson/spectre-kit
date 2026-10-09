import Testing

@testable import SpectreKit

struct ColorTests {
    @Test func colorDowngradeFromRgbToStandard() throws {
        // Given
        let color = Color.rgb(10, 10, 170)
        // When
        let result = color.convert(to: ColorSystem.standard)
        // Then
        #expect(Color.number(4) == result)
    }

    @Test func colorDowngradeFromRgbToEightBit() throws {
        // Given
        let color = Color.rgb(10, 10, 170)
        // When
        let result = color.convert(to: ColorSystem.eightBit)
        // Then
        #expect(Color.number(19) == result)
    }

    @Test func colorDowngradeFromEightBitToStandard() throws {
        // Given
        let color = Color.number(65)
        // When
        let result = color.convert(to: ColorSystem.standard)
        // Then
        #expect(Color.number(8) == result)
    }

    @Test func colorDowngradeFromTrueColorToStandard() throws {
        // Given
        let color = Color.rgb(10, 10, 170)
        // When
        let result = color.convert(to: ColorSystem.standard)
        // Then
        #expect(Color.number(4) == result)
    }
}
