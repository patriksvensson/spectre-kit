import Testing

@testable import SpectreKit

struct PanelTests {
    @Test func renderPanel() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌─────────────┐
                │ Hello World │
                └─────────────┘

                """)
    }

    @Test func renderPanelZeroPadding() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.padding = Padding(left: 0, top: 0, right: 0, bottom: 0)

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌───────────┐
                │Hello World│
                └───────────┘

                """)
    }

    @Test func renderPanelWithPadding() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.padding = Padding(left: 3, top: 1, right: 5, bottom: 2)

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌───────────────────┐
                │                   │
                │   Hello World     │
                │                   │
                │                   │
                └───────────────────┘

                """)
    }

    @Test func renderPanelWithHeader() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.header = PanelHeader("Greeting")

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌─Greeting────┐
                │ Hello World │
                └─────────────┘

                """)
    }

    @Test func renderPanelWithCenteredHeader() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.header = PanelHeader("Greeting")
        panel.header?.justification = Justify.center

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌──Greeting───┐
                │ Hello World │
                └─────────────┘

                """)
    }

    @Test func renderPanelWithRightAlignedHeader() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.header = PanelHeader("Greeting")
        panel.header?.justification = Justify.right

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌────Greeting─┐
                │ Hello World │
                └─────────────┘

                """)
    }

    @Test func renderPanelWithRightHeaderThatWillNotFit() {
        // Given
        let console = TestConsole(width: 10)
        let panel = Panel("Hello World")
        panel.header = PanelHeader("Greeting")
        panel.header?.justification = Justify.left

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌─Greet…─┐
                │ Hello  │
                │ World  │
                └────────┘

                """)
    }

    @Test func renderPanelWithUnicode() {
        // Given
        let console = TestConsole()
        let panel = Panel(" \n💩\n ")

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌────┐
                │    │
                │ 💩 │
                │    │
                └────┘

                """)
    }

    @Test func renderPanelWithExplicitLineEndings() {
        // Given
        let console = TestConsole()
        let panel = Panel("I heard [underline on blue]you[/] like 📦\n\n\n\nSo I put a 📦 in a 📦")

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌───────────────────────┐
                │ I heard you like 📦   │
                │                       │
                │                       │
                │                       │
                │ So I put a 📦 in a 📦 │
                └───────────────────────┘

                """)
    }

    @Test func renderPanelWithExplicitWidth() {
        // Given
        let console = TestConsole()
        let panel = Panel("Hello World")
        panel.width = 25

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌───────────────────────┐
                │ Hello World           │
                └───────────────────────┘

                """)
    }

    @Test func renderPanelWithMaxWidthIfExplicitWidthIsTooLarge() {
        // Given
        let console = TestConsole(width: 20)
        let panel = Panel("Hello World")
        panel.width = 25

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌──────────────────┐
                │ Hello World      │
                └──────────────────┘

                """)
    }

    @Test func renderPanelWithCenteredChild() {
        // Given
        let console = TestConsole()
        let text = Text("Hello World")
        text.justification = Justify.center
        let panel = Panel(text)
        panel.width = 40

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌──────────────────────────────────────┐
                │             Hello World              │
                └──────────────────────────────────────┘

                """)
    }

    @Test func renderPanelWithCJK() {
        // Given
        let console = TestConsole()
        let panel = Panel("测试")
        panel.header = PanelHeader("测试")
        panel.header?.justification = Justify.right

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌─测试─┐
                │ 测试 │
                └──────┘

                """)
    }

    @Test func renderPanelWithWrappedText() {
        // Given
        let console = TestConsole.init(width: 25)
        let panel = Panel("Lorem ipsum dolor sit amet, consectetur adipiscing elit. ")

        // When
        let result = console.write(panel)

        // Then
        #expect(
            result == """
                ┌───────────────────────┐
                │ Lorem ipsum dolor sit │
                │ amet, consectetur     │
                │ adipiscing elit.      │
                └───────────────────────┘

                """)
    }
}
