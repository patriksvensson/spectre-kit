import Foundation
import SpectreKit
let console = Console()

// Write some markuped text
// to the terminal.
console.writeLine()
console.markupLine(
    """
    [red]Hello World[/] from
    [yellow]Spectre[/][blue]Kit[/]
    """)

// Write regular (word wrapped)
// text to the terminal.
console.writeLine()
console.writeLine("Goodbye!")
