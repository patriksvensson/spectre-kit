import XCTest

@testable import SpectreKit

final class RuleTests: XCTestCase {
    func testRenderRuleWithoutTitle() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule()

        // When
        let result = console.write(rule)

        // Then
        XCTAssertEqual(
            result,
            """
            ─────────────────────────

            """)
    }

    func testRenderRuleWithHeader() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello World")

        // When
        let result = console.write(rule)

        // Then
        XCTAssertEqual(
            result,
            """
            ────── Hello World ──────

            """)
    }

    func testRenderRuleWithLeftAlignedHeader() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello World")
        rule.justification = Justify.left

        // When
        let result = console.write(rule)

        // Then
        XCTAssertEqual(
            result,
            """
            ── Hello World ──────────

            """)
    }

    func testRenderRuleWithRightAlignedHeader() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello World")
        rule.justification = Justify.right

        // When
        let result = console.write(rule)

        // Then
        XCTAssertEqual(
            result,
            """
            ────────── Hello World ──

            """)
    }

    func testRenderRuleWithExplicitBorder() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule()
        rule.border = BoxBorder.double

        // When
        let result = console.write(rule)

        // Then
        XCTAssertEqual(
            result,
            """
            ═════════════════════════

            """)
    }

    func testRenderRuleWithExplicitBorderAndHeader() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello World")
        rule.border = BoxBorder.double

        // When
        let result = console.write(rule)

        // Then
        XCTAssertEqual(
            result,
            """
            ══════ Hello World ══════

            """)
    }

    func testRenderRuleWithLineBreaks() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello\nWorld\r\n!")

        // When
        let result = console.write(rule)

        // Then
        XCTAssertEqual(
            result,
            """
            ───── Hello World ! ─────

            """)
    }

    func testRuleTitleIsTrimmed() {
        let testData = [
            (1, "Hello World Hello World Hello World Hello World Hello World", "─\n"),
            (2, "Hello World Hello World Hello World Hello World Hello World", "──\n"),
            (3, "Hello World Hello World Hello World Hello World Hello World", "───\n"),
            (4, "Hello World Hello World Hello World Hello World Hello World", "────\n"),
            (5, "Hello World Hello World Hello World Hello World Hello World", "─────\n"),
            (6, "Hello World Hello World Hello World Hello World Hello World", "──────\n"),
            (7, "Hello World Hello World Hello World Hello World Hello World", "───────\n"),
            (8, "Hello World Hello World Hello World Hello World Hello World", "── H… ──\n"),
            (8, "A", "── A ───\n"),
            (8, "AB", "── AB ──\n"),
            (8, "ABC", "── A… ──\n"),
            (
                40, "Hello World Hello World Hello World Hello World Hello World",
                "──── Hello World Hello World Hello… ────\n"
            ),
        ]

        for (width, input, expected) in testData {
            XCTContext.runActivity(named: "Trimmed rule") { _ in
                let console = TestConsole(width: width)
                let rule = Rule(title: input)
                let result = console.write(rule)
                XCTAssertEqual(expected, result)
            }
        }
    }
}
