import std/strformat
import std/terminal
import bars
import config

# Print the title if any
proc show_title(title: string) =
    if title != "":
        echo &"{ansiStyleCode(styleBright)}{title}{ansiResetCode}\n"

# Main
let conf = get_config()
if conf.padding: echo ""
show_title(conf.title)
show_bars(conf)
if conf.padding: echo ""