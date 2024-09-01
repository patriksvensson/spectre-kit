import Foundation
import SpectreKit

let console = Console()

console.write(
    Panel("[green]Hello World[/] from [yellow]Spectre[/][blue]Kit[/]")
        .setWidth(50)
        .setBorder(BoxBorder.double)
        .setBorderStyle(Style(foreground: Color.rgb(128, 64, 0)))
        .setHeader("[green]T[/][blue]e[/][yellow]s[/][red]t[/]")
        .setHeaderAlignment(Justify.center))
