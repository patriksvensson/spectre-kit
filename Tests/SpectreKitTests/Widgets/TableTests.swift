import XCTest

@testable import SpectreKit

final class TableTests: XCTestCase {
    func testRenderTable() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌────────┬────────┬───────┐
            │ Foo    │ Bar    │ Baz   │
            ├────────┼────────┼───────┤
            │ Qux    │ Corgi  │ Waldo │
            │ Grault │ Garply │ Fred  │
            └────────┴────────┴───────┘

            """)
    }

    func testRenderRowSeparators() {
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
        XCTAssertEqual(
            result,
            """
            ┌────────┬────────┬───────┐
            │ Foo    │ Bar    │ Baz   │
            ├────────┼────────┼───────┤
            │ Qux    │ Corgi  │ Waldo │
            ├────────┼────────┼───────┤
            │ Grault │ Garply │ Fred  │
            └────────┴────────┴───────┘

            """)
    }

    func testRenderRowSeparatorsWithoutheaders() {
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
        XCTAssertEqual(
            result,
            """
            ┌────────┬────────┬───────┐
            │ Qux    │ Corgi  │ Waldo │
            ├────────┼────────┼───────┤
            │ Grault │ Garply │ Fred  │
            └────────┴────────┴───────┘

            """)
    }

    func testRenderTableWithEACharacters() {
        // Given
        let console = TestConsole(width: 48)
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("中文", "日本語", "한국어")
        table.addRow("这是中文测试字符串", "これは日本語のテスト文字列です", "이것은한국어테스트문자열입니다")

        // When
        let result = console.write(table)

        // Then
        XCTAssertEqual(
            result,
            """
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

    func testRenderColumnJustifications() {
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
        XCTAssertEqual(
            result,
            """
            ┌────────┬────────────────┬─────────────┐
            │ Foo    │      Bar       │         Baz │
            ├────────┼────────────────┼─────────────┤
            │ Qux    │ Dolor sit amet │       Waldo │
            ├────────┼────────────────┼─────────────┤
            │ Grault │     Garply     │ Lorem ipsum │
            └────────┴────────────────┴─────────────┘

            """)
    }

    func testExpandToAvailableSpace() {
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
        XCTAssertEqual(
            result,
            """
            ┌──────────────────────────┬───────────────────────────┬───────────────────────┐
            │ Foo                      │ Bar                       │ Baz                   │
            ├──────────────────────────┼───────────────────────────┼───────────────────────┤
            │ Qux                      │ Corgi                     │ Waldo                 │
            │ Grault                   │ Garply                    │ Fred                  │
            └──────────────────────────┴───────────────────────────┴───────────────────────┘

            """)
    }

    func testRenderFooters() {
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
        XCTAssertEqual(
            result,
            """
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

    func testRenderTableWrappedInPanel() {
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
        XCTAssertEqual(
            result,
            """
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

    func testRenderMultipleCellLines() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux\nQuuux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌────────┬────────┬───────┐
            │ Foo    │ Bar    │ Baz   │
            ├────────┼────────┼───────┤
            │ Qux    │ Corgi  │ Waldo │
            │ Quuux  │        │       │
            │ Grault │ Garply │ Fred  │
            └────────┴────────┴───────┘

            """)
    }

    func testRenderCellPadding() {
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
        XCTAssertEqual(
            result,
            """
            ┌────────┬────────┬──────────────┐
            │ Foo    │ Bar    │      Baz     │
            ├────────┼────────┼──────────────┤
            │ Qux    │ Corgi  │      Waldo   │
            │ Quuux  │        │              │
            │ Grault │ Garply │      Fred    │
            └────────┴────────┴──────────────┘

            """)
    }

    func testRenderNoRows() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("Foo", "Bar", "Baz")

        // When
        let result = console.write(table)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌─────┬─────┬─────┐
            │ Foo │ Bar │ Baz │
            └─────┴─────┴─────┘

            """)
    }

    func testRenderEmptyColumn() {
        // Given
        let console = TestConsole()
        let table = Table()
        table.addColumns("", "")
        table.addRow("", "A")
        table.addRow("", "B")

        // When
        let result = console.write(table)

        // Then
        XCTAssertEqual(
            result,
            """
            ┌──┬───┐
            │  │   │
            ├──┼───┤
            │  │ A │
            │  │ B │
            └──┴───┘

            """)
    }

    func testRenderFold() {
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
        XCTAssertEqual(
            result,
            """
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

    func testRenderRightAligned() {
        // Given
        let console = TestConsole(width: 40)
        let table = Table().rightAligned()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        XCTAssertEqual(
            result,
            """
                         ┌────────┬────────┬───────┐
                         │ Foo    │ Bar    │ Baz   │
                         ├────────┼────────┼───────┤
                         │ Qux    │ Corgi  │ Waldo │
                         │ Grault │ Garply │ Fred  │
                         └────────┴────────┴───────┘

            """)
    }

    func testRenderLeftAligned() {
        // Given
        let console = TestConsole(width: 40)
        let table = Table().centered()
        table.addColumns("Foo", "Bar", "Baz")
        table.addRow("Qux", "Corgi", "Waldo")
        table.addRow("Grault", "Garply", "Fred")

        // When
        let result = console.write(table)

        // Then
        XCTAssertEqual(
            result,
            """
                  ┌────────┬────────┬───────┐       
                  │ Foo    │ Bar    │ Baz   │       
                  ├────────┼────────┼───────┤       
                  │ Qux    │ Corgi  │ Waldo │       
                  │ Grault │ Garply │ Fred  │       
                  └────────┴────────┴───────┘       

            """)
    }
}
