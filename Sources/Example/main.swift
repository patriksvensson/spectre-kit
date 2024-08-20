import Foundation
import SpectreKit

let console = Console()

// Write some markuped text
// to the terminal.
console.writeLine("Demo")
console.markupLine(
    """
    [red]Hello World[/] from
    [yellow]Spectre[/][blue]Kit[/]
    """)

// Write regular (word wrapped)
// text to the terminal.
console.write(Padder(Text("Goodbye!"), Padding(horizontal: 3, vertical: 0)))
