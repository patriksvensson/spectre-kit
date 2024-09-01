import Foundation
import SpectreKit

let console = Console()

let panel = Panel("""
    [red]Hello World[/] from
    [yellow]Spectre[/][blue]Kit[/]
    """)
panel.header = PanelHeader("[green]T[/][blue]e[/][yellow]s[/][red]t[/]")
panel.header?.justification = Justify.center

console.write(panel)
