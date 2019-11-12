import os
import terminal
import strutils
import algorithm
import parseopt
import strformat

type Data = object
    label: string
    amount: float

type Config = object
    source: string
    title: string
    units: string
    symbol: string
    colors: bool
    reverse: bool
    nreverse: bool
    padding: bool
    values: bool
    percentages: bool
    numbers: bool
    spacing: bool

# Round to 2 decimal places
proc rounded(n: float): string =
    n.formatFloat(ffDecimal, 2)

# Get the longest label length
proc max_label(data: seq[Data]): int =
    var len = 0
    for i in data:
        let ln = i.label.len()
        if ln > len:
            len = ln
    len 

# Get the total amount
proc amount_sum(data: seq[Data]): float =
    var n = 0.0
    for i in data:
        n += i.amount
    n

# Print a data item
proc bar(data: Data, lablen: int, asum: float, config: Config, index:int, dlen: int) =
    var per = (data.amount / asum) * 100
    var line = ""

    for i in 0..int(per):
        line.add(config.symbol)

    var blue = ""
    var green = ""
    var cyan = ""
    var reset = ""
    var value = ""
    var percentage = ""
    var units = ""
    var number = ""
    var ps = ""
    var vs = ""

    if config.colors:
        blue = ansiForegroundColorCode(fgBlue)
        green = ansiForegroundColorCode(fgGreen)
        cyan = ansiForegroundColorCode(fgCyan)
        reset = ansiResetCode
    
    if config.values:
        var us = ""
        if config.units != "":
            us = " "
        value = &"{blue}[{rounded(data.amount)}{us}{config.units}]"
    
    if config.percentages:
        percentage = &"{green}[{rounded(per)} %]"
    
    if config.values or config.percentages:
        ps = " "
    
    if config.values and config.percentages:
        vs = " "
    
    var spn = 0
    var sp = ""
    
    if config.numbers:
        spn = lablen - data.label.len() - intToStr(index).len() + 2
        number = &"{cyan}({index}){reset}"
    
    else:        
        spn = lablen - data.label.len() - 1

    for i in 0..spn:
        sp.add(" ")
        
    echo &"{number}{sp}{data.label} {line}{ps}{value}{vs}{percentage}{reset}"

# After getting the data and config
# perform the main operations
proc process(data: seq[Data], config: Config) = 
    if config.padding: echo ""
    if config.title != "":
        echo &"{ansiStyleCode(styleBright)}{config.title}{ansiResetCode}\n"
    var data = data.sortedByIt(it.amount)
    if config.reverse:
        data.reverse()
    let lablen = max_label(data)
    let asum = amount_sum(data)
    let dlen = data.len()
    var index = 1
    if config.nreverse:
        index = dlen
    for i, d in data:
        bar(d, lablen, asum, config, index, dlen)
        if config.spacing and i < dlen - 1:
            echo ""
        if config.nreverse:
            index -= 1
        else:
            index += 1
    if config.padding: echo ""

# Main
# Get all necessary data

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
    quit(0)

# Read file
let fcontent = readfile(source).strip()
let split = fcontent.splitLines()
var n = split.len()

var dlines: seq[string]

# Check for metadata
# And collect data lines
for line in split:
    let ls = line.strip()
    if ls == "": continue
    if ls.startsWith("title:"):
        title = ls.replace("title:", "").strip()
    elif ls.startsWith("units:"):
        units = ls.replace("units:", "").strip()
    else: dlines.add(ls)

# Create the config object
let config = Config(source:source, title:title, units:units, colors:colors, 
reverse:reverse, nreverse:nreverse, padding:padding, values:values, 
percentages:percentages, numbers:numbers, spacing: spacing, symbol: symbol)

var data: seq[Data]

# Parse each data line
for line in dlines:
    let d = line.split(" ")
    data.add(Data(label: d[0..^2].join(" ").strip(), amount: parseFloat(d[^1])))

process(data, config)