import Foundation
import SpectreKit

let console = Console()

console.write(
    Panel(
        Table()
            .addColumns("Foo", "[green]Bar[/]", "Baz")
            .addRow(Markup("[red]abc[/]"), Text("def"), Markup("[yellow]lol[/]"))
            .addRow(
                Markup("[green bold]Corgi[/]"), Text("jkl"),
                Table()
                    .addColumn("Key")
                    .addColumn("Value")
                    .addRow(Markup("[red]Width[/]"), Text("\(console.width)"))
                    .addRow(Markup("[green]Height[/]"), Text("\(console.height)"))
                    .addRow(Markup("[yellow]Terminal[/]"), Text("\(console.terminal.type)"))
                    .setBorder(TableBorder.doubleEdge)
                    .setTitle("A table in a table in a panel")
                    .setCaption("A [blue]caption[/]")
            )
            .setTitle("A table in a panel")
            .setBorder(TableBorder.rounded)
    )
    .setHeader("[white]A panel[/]")
    .setBorderColor(Color.rgb(255, 128, 0)))
