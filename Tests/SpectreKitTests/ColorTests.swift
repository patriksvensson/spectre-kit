import XCTest
@testable import SpectreKit

final class PrimitivesTests: XCTestCase {
    func testColorDowngradeFromRgbToStandard() throws {
        // Given
        let color = Color.rgb(10, 10, 170)
        // When
        let result = color.downgrade(to: ColorSystem.standard)
        // Then
        XCTAssertEqual(Color.number(4), result)
    }
    
    func testColorDowngradeFromRgbToEightBit() throws {
        // Given
        let color = Color.rgb(10, 10, 170)
        // When
        let result = color.downgrade(to: ColorSystem.eightBit)
        // Then
        XCTAssertEqual(Color.number(19), result)
    }
    
    func testColorDowngradeFromEightBitToStandard() throws {
        // Given
        let color = Color.number(65)
        // When
        let result = color.downgrade(to: ColorSystem.standard)
        // Then
        XCTAssertEqual(Color.number(8), result)
    }
    
    func testColorDowngradeFromTrueColorToStandard() throws {
        // Given
        let color = Color.rgb(10, 10, 170)
        // When
        let result = color.downgrade(to: ColorSystem.standard)
        // Then
        XCTAssertEqual(Color.number(4), result)
    }
}
