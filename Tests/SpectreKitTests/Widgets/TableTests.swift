import Testing

@testable import SpectreKit

struct TableTests {
    @Test func renderTable() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌────────┬────────┬───────┐
                │ Foo    │ Bar    │ Baz   │
                ├────────┼────────┼───────┤
                │ Qux    │ Corgi  │ Waldo │
                │ Grault │ Garply │ Fred  │
                └────────┴────────┴───────┘

                """)
    }

    @Test func renderRowSeparators() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.showRowSeparators = true
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌────────┬────────┬───────┐
                │ Foo    │ Bar    │ Baz   │
                ├────────┼────────┼───────┤
                │ Qux    │ Corgi  │ Waldo │
                ├────────┼────────┼───────┤
                │ Grault │ Garply │ Fred  │
                └────────┴────────┴───────┘

                """)
    }

    @Test func renderRowSeparatorsWithoutheaders() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.showRowSeparators = true
        table.showHeaders = false
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌────────┬────────┬───────┐
                │ Qux    │ Corgi  │ Waldo │
                ├────────┼────────┼───────┤
                │ Grault │ Garply │ Fred  │
                └────────┴────────┴───────┘

                """)
    }

    @Test func renderTableWithEACharacters() {
        // Given
        let console = TestConsole(width: 48)
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("中文", "日本語", "한국어")
        table.addRow("这是中文测试字符串", "これは日本語のテスト文字列です", "이것은한국어테스트문자열입니다")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌───────────────┬───────────────┬──────────────┐
                │ Foo           │ Bar           │ Baz          │
                ├───────────────┼───────────────┼──────────────┤
                │ 中文          │ 日本語        │ 한국어       │
                │ 这是中文测试  │ これは日本語  │ 이것은한국어 │
                │ 字符串        │ のテスト文字  │ 테스트문자열 │
                │               │ 列です        │ 입니다       │
                └───────────────┴───────────────┴──────────────┘

                """)
    }

    @Test func renderColumnJustifications() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.showRowSeparators = true
        table.addColumn(TableColumn("Foo").leftAligned())
        table.addColumn(TableColumn("Bar").centered())
        table.addColumn(TableColumn("Baz").rightAligned())
        table.addRow("Qux", "Dolor sit amet", "Waldo")
        table.addRow("Grault", "Garply", "Lorem ipsum")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌────────┬────────────────┬─────────────┐
                │ Foo    │      Bar       │         Baz │
                ├────────┼────────────────┼─────────────┤
                │ Qux    │ Dolor sit amet │       Waldo │
                ├────────┼────────────────┼─────────────┤
                │ Grault │     Garply     │ Lorem ipsum │
                └────────┴────────────────┴─────────────┘

                """)
    }

    @Test func expandToAvailableSpace() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.expand = true
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌──────────────────────────┬───────────────────────────┬───────────────────────┐
                │ Foo                      │ Bar                       │ Baz                   │
                ├──────────────────────────┼───────────────────────────┼───────────────────────┤
                │ Qux                      │ Corgi                     │ Waldo                 │
                │ Grault                   │ Garply                    │ Fred                  │
                └──────────────────────────┴───────────────────────────┴───────────────────────┘

                """)
    }

    @Test func renderFooters() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumn(TableColumn("Foo").setFooter("Oof").rightAligned())
        table.addColumn(TableColumn("Bar"))
        table.addColumn(TableColumn("Baz").setFooter("Zab"))
        table.addRow("Qux", "[blue]Corgi[/]", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌────────┬────────┬───────┐
                │    Foo │ Bar    │ Baz   │
                ├────────┼────────┼───────┤
                │    Qux │ Corgi  │ Waldo │
                │ Grault │ Garply │ Fred  │
                ├────────┼────────┼───────┤
                │    Oof │        │ Zab   │
                └────────┴────────┴───────┘

                """)
    }

    @Test func renderTableWrappedInPanel() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumn("Foo")
        table.addColumn("Bar")
        table.addColumn("Baz")
        table.addRow("Qux\nQuuuuuux", "[blue]Corgi[/]", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(
            Panel(Panel(table).setBorder(BoxBorder.ascii))
        )

        // Then
        #expect(
            result == """
                ┌───────────────────────────────────┐
                │ +-------------------------------+ │
                │ | ┌──────────┬────────┬───────┐ | │
                │ | │ Foo      │ Bar    │ Baz   │ | │
                │ | ├──────────┼────────┼───────┤ | │
                │ | │ Qux      │ Corgi  │ Waldo │ | │
                │ | │ Quuuuuux │        │       │ | │
                │ | │ Grault   │ Garply │ Fred  │ | │
                │ | └──────────┴────────┴───────┘ | │
                │ +-------------------------------+ │
                └───────────────────────────────────┘

                """)
    }

    @Test func renderMultipleCellLines() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux\nQuuux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌────────┬────────┬───────┐
                │ Foo    │ Bar    │ Baz   │
                ├────────┼────────┼───────┤
                │ Qux    │ Corgi  │ Waldo │
                │ Quuux  │        │       │
                │ Grault │ Garply │ Fred  │
                └────────┴────────┴───────┘

                """)
    }

    @Test func renderCellPadding() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("Foo", "Bar")
        table.addColumn(TableColumn("Baz").padding(left: 6, top: 0, right: 3, bottom: 0))
        table.addRow("Qux\nQuuux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌────────┬────────┬──────────────┐
                │ Foo    │ Bar    │      Baz     │
                ├────────┼────────┼──────────────┤
                │ Qux    │ Corgi  │      Waldo   │
                │ Quuux  │        │              │
                │ Grault │ Garply │      Fred    │
                └────────┴────────┴──────────────┘

                """)
    }

    @Test func renderNoRows() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌─────┬─────┬─────┐
                │ Foo │ Bar │ Baz │
                └─────┴─────┴─────┘

                """)
    }

    @Test func renderEmptyColumn() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("", "")
        table.addRow("", "A")
        table.addRow("", "B")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                ┌──┬───┐
                │  │   │
                ├──┼───┤
                │  │ A │
                │  │ B │
                └──┴───┘

                """)
    }

    @Test func renderFold() {
        // Given
        let console = TestConsole(width: 30)
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux With A Long Description", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred On A Long Long Walk")

        // When
        let result = console.write(
            Panel(table).setBorder(BoxBorder.double))

        // Then
        #expect(
            result == """
                ╔════════════════════════════╗
                ║ ┌────────┬───────┬───────┐ ║
                ║ │ Foo    │ Bar   │ Baz   │ ║
                ║ ├────────┼───────┼───────┤ ║
                ║ │ Qux    │ Corgi │ Waldo │ ║
                ║ │ With A │       │       │ ║
                ║ │ Long   │       │       │ ║
                ║ │ Descri │       │       │ ║
                ║ │ ption  │       │       │ ║
                ║ │ Grault │ Garpl │ Fred  │ ║
                ║ │        │ y     │ On A  │ ║
                ║ │        │       │ Long  │ ║
                ║ │        │       │ Long  │ ║
                ║ │        │       │ Walk  │ ║
                ║ └────────┴───────┴───────┘ ║
                ╚════════════════════════════╝

                """)
    }

    @Test func renderRightAligned() {
        // Given
        let console = TestConsole(width: 40)
        let table = Table().rightAligned()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                             ┌────────┬────────┬───────┐
                             │ Foo    │ Bar    │ Baz   │
                             ├────────┼────────┼───────┤
                             │ Qux    │ Corgi  │ Waldo │
                             │ Grault │ Garply │ Fred  │
                             └────────┴────────┴───────┘

                """)
    }

    @Test func renderLeftAligned() {
        // Given
        let console = TestConsole(width: 40)
        let table = Table().centered()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        #expect(
            result == """
                      ┌────────┬────────┬───────┐       
                      │ Foo    │ Bar    │ Baz   │       
                      ├────────┼────────┼───────┤       
                      │ Qux    │ Corgi  │ Waldo │       
                      │ Grault │ Garply │ Fred  │       
                      └────────┴────────┴───────┘       

                """)
    }
}
