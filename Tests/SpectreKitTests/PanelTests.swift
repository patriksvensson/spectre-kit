import XCTest

@testable import SpectreKit

final class PanelTests: XCTestCase {
    func testRenderPanel() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌─────────────┐
            │ Hello World │
            └─────────────┘

            """)
    }

    func testRenderPanelZeroPadding() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.padding = Padding(left: 0, top: 0, right: 0, bottom: 0)

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌───────────┐
            │Hello World│
            └───────────┘

            """)
    }

    func testRenderPanelWithPadding() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.padding = Padding(left: 3, top: 1, right: 5, bottom: 2)

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌───────────────────┐
            │                   │
            │   Hello World     │
            │                   │
            │                   │
            └───────────────────┘

            """)
    }

    func testRenderPanelWithHeader() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.header = PanelHeader("Greeting")

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌─Greeting────┐
            │ Hello World │
            └─────────────┘

            """)
    }

    func testRenderPanelWithCenteredHeader() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.header = PanelHeader("Greeting")
        panel.header?.justification = Justify.center

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌──Greeting───┐
            │ Hello World │
            └─────────────┘

            """)
    }

    func testRenderPanelWithRightAlignedHeader() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.header = PanelHeader("Greeting")
        panel.header?.justification = Justify.right

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌────Greeting─┐
            │ Hello World │
            └─────────────┘

            """)
    }

    func testRenderPanelWithRightHeaderThatWillNotFit() {
        // Given
        let console = TestConsole(width: 10)
        let panel = Panel("Hello World")
        panel.header = PanelHeader("Greeting")
        panel.header?.justification = Justify.left

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌─Greet…─┐
            │ Hello  │
            │ World  │
            └────────┘

            """)
    }

    func testRenderPanelWithUnicode() {
        // Given
        let console = TestConsole()
        let panel = Panel(" \n💩\n ")

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌────┐
            │    │
            │ 💩 │
            │    │
            └────┘

            """)
    }

    func testRenderPanelWithExplicitLineEndings() {
        // Given
        let console = TestConsole()
        let panel = Panel("I heard [underline on blue]you[/] like 📦\n\n\n\nSo I put a 📦 in a 📦")

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌───────────────────────┐
            │ I heard you like 📦   │
            │                       │
            │                       │
            │                       │
            │ So I put a 📦 in a 📦 │
            └───────────────────────┘

            """)
    }

    func testRenderPanelWithExplicitWidth() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.width = 25

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌───────────────────────┐
            │ Hello World           │
            └───────────────────────┘

            """)
    }

    func testRenderPanelWithMaxWidthIfExplicitWidthIsTooLarge() {
        // Given
        let console = TestConsole(width: 20)
        let panel = Panel("Hello World")
        panel.width = 25

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌──────────────────┐
            │ Hello World      │
            └──────────────────┘

            """)
    }

    func testRenderPanelWithCenteredChild() {
        // Given
        let console = TestConsole()
        let text = Text("Hello World")
        text.justification = Justify.center
        let panel = Panel(text)
        panel.width = 40

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌──────────────────────────────────────┐
            │             Hello World              │
            └──────────────────────────────────────┘

            """)
    }

    func testRenderPanelWithCJK() {
        // Given
        let console = TestConsole()
        let panel = Panel("测试")
        panel.header = PanelHeader("测试")
        panel.header?.justification = Justify.right

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌─测试─┐
            │ 测试 │
            └──────┘

            """)
    }

    func testRenderPanelWithWrappedText() {
        // Given
        let console = TestConsole.init(width: 25)
        let panel = Panel("Lorem ipsum dolor sit amet, consectetur adipiscing elit. ")

        // When
        let result = console.write(panel)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌───────────────────────┐
            │ Lorem ipsum dolor sit │
            │ amet, consectetur     │
            │ adipiscing elit.      │
            └───────────────────────┘

            """)
    }
}
