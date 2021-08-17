import std/strutils
import structs

# Round to 2 decimal places
proc rounded*(n: float): string =
    n.formatFloat(ffDecimal, 2)

# Get the longest label length
proc max_label*(data: seq[Data]): int =
    var len = 0
    for i in data:
        let ln = i.label.len()
        if ln > len:
            len = ln
    len 

# get the highest data item
proc highest_amount*(data: seq[Data]): float =
    var highest = 0.0

    for item in data:
        if item.amount > highest:
            highest = item.amount
    highest