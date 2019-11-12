import structs
import strutils

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

# Get the total amount
proc amount_sum*(data: seq[Data]): float =
    var n = 0.0
    for i in data:
        n += i.amount
    n