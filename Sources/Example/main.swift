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
                    .addColumn("Foo")
                    .addColumn("Bar")
                    .addColumn("Baz")
                    .addRow(Markup("[red]abc[/]"), Text("def"), Markup("[yellow]lol[/]"))
                    .addRow(Markup("[green bold]Corgi[/]"), Text("jkl"), Markup("[blue]wtf[/]"))
                    .setBorder(TableBorder.doubleEdge)
                    .setTitle("A table in a table in a panel")
                    .setCaption("A [blue]caption[/]")
            )
            .setTitle("A table in a panel")
            .setBorder(TableBorder.rounded)
    )
    .setHeader("[white]A panel[/]")
    .setBorderColor(Color.rgb(255, 128, 0)))
