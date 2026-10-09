import Testing

@testable import SpectreKit

struct RuleTests {
    @Test func renderRuleWithoutTitle() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule()

        // When
        let result = console.write(rule)

        // Then
        #expect(
            result == """
                ─────────────────────────

                """)
    }

    @Test func renderRuleWithHeader() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello World")

        // When
        let result = console.write(rule)

        // Then
        #expect(
            result == """
                ────── Hello World ──────

                """)
    }

    @Test func renderRuleWithLeftAlignedHeader() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello World")
        rule.justification = Justify.left

        // When
        let result = console.write(rule)

        // Then
        #expect(
            result == """
                ── Hello World ──────────

                """)
    }

    @Test func renderRuleWithRightAlignedHeader() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello World")
        rule.justification = Justify.right

        // When
        let result = console.write(rule)

        // Then
        #expect(
            result == """
                ────────── Hello World ──

                """)
    }

    @Test func renderRuleWithExplicitBorder() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule()
        rule.border = BoxBorder.double

        // When
        let result = console.write(rule)

        // Then
        #expect(
            result == """
                ═════════════════════════

                """)
    }

    @Test func renderRuleWithExplicitBorderAndHeader() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello World")
        rule.border = BoxBorder.double

        // When
        let result = console.write(rule)

        // Then
        #expect(
            result == """
                ══════ Hello World ══════

                """)
    }

    @Test func renderRuleWithLineBreaks() {
        // Given
        let console = TestConsole(width: 25)
        let rule = Rule(title: "Hello\nWorld\r\n!")

        // When
        let result = console.write(rule)

        // Then
        #expect(
            result == """
                ───── Hello World ! ─────

                """)
    }

    private static var titleIsTrimmedTests = [
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

    @Test(arguments: titleIsTrimmedTests)
    func ruleTitleIsTrimmed(_ test: (Int, String, String)) {
        let (width, input, expected) = test
        let console = TestConsole(width: width)
        let rule = Rule(title: input)
        let result = console.write(rule)
        #expect(expected == result)
    }
}
