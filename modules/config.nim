import structs
import os
import parseopt
import strutils

proc get_config*(): Config =
    var arg = initOptParser(commandLineParams())
    var source = ""
    var title = ""
    var units = ""
    var colors = true
    var reverse = false
    var nreverse = false
    var padding = true
    var values = true
    var percentages = true
    var numbers = false
    var spacing = false
    var symbol = "="
    
    # Check the arguments
    while true:
        arg.next()
        case arg.kind
        of cmdEnd: break
        of cmdLongOption:
            if arg.key == "no-colors":
                colors = false
            elif arg.key == "reverse":
                reverse = true
            elif arg.key == "nreverse":
                nreverse = true
            elif arg.key == "no-padding":
                padding = false
            elif arg.key == "no-values":
                values = false
            elif arg.key == "no-percentages":
                percentages = false
            elif arg.key == "numbers":
                numbers = true
            elif arg.key == "spacing":
                spacing = true
            elif arg.key == "symbol":
                symbol = arg.val
        of cmdArgument:
            source = arg.key
        else: discard
    
    if source == "":
        echo "No file path provided."
        quit(0)

    # Read file
    let fcontent = readfile(source).strip()
    let split = fcontent.splitLines()
    var dlines: seq[string]

    # Check for metadata
    # And collect data lines
    for line in split:
        let ls = line.strip()
        if ls == "": continue
        elif ls.startsWith("#"):
            continue
        elif ls.startsWith("title:"):
            title = ls.replace("title:", "").strip()
        elif ls.startsWith("units:"):
            units = ls.replace("units:", "").strip()
        else: dlines.add(ls)
    
    # Start data sequence
    var data: seq[Data]

    # Parse each data line
    for line in dlines:
        let d = line.split(" ")
        data.add(Data(label: d[0..^2].join(" ").strip(), amount: parseFloat(d[^1])))

    # Return the config object
    Config(data:data, source:source, title:title, units:units, colors:colors, reverse:reverse, 
    nreverse:nreverse, padding:padding, values:values, symbol: symbol, percentages:percentages, 
    numbers:numbers, spacing: spacing)