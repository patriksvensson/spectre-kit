# `SpectreKit`

A Swift library that makes it easier to create beautiful terminal applications.  

It is a port of [Spectre.Console](https://spectreconsole.net) which in turn is heavily inspired by 
the excellent Python library, [Rich](https://github.com/Textualize/rich).

> [!NOTE]
> SpectreKit is currently under development, and many things are still missing.

## Example

```swift
import SpectreKit

// Create a console instance
let console = Console()

// Write some markup text to the console
console.markup("[blue]Hello[/] ")
console.markupLine("[green]World[/]!")

// Render a panel to the console
// with some colorful text.
console.write(Panel("""
    [red]Hello World[/] from
    [yellow]Spectre[/][blue]Kit[/]
    """))
```