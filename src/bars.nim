import utils
import structs
import terminal
import strutils
import algorithm
import strformat

# Print a data item
proc bar*(data: Data, lablen: int, asum: float, conf: Config, index:int) =
    var per = (data.amount / asum) * 100
    var line = conf.start_symbol
    let sd = int(per / conf.density)

    for i in 0..sd:
        line.add(conf.symbol)
    
    line.add(conf.end_symbol)

    var blue = ""
    var green = ""
    var cyan = ""
    var reset = ""
    var value = ""
    var percentage = ""
    var number = ""
    var ps = ""
    var vs = ""

    if conf.colors:
        blue = ansiForegroundColorCode(fgBlue)
        green = ansiForegroundColorCode(fgGreen)
        cyan = ansiForegroundColorCode(fgCyan)
        reset = ansiResetCode
    
    if conf.values:
        var us = ""
        if conf.units != "":
            us = " "
        value = &"{blue}[{rounded(data.amount)}{us}{conf.units}]"
    
    if conf.percentages:
        percentage = &"{green}[{rounded(per)} %]"
    
    if conf.values or conf.percentages:
        ps = " "
    
    if conf.values and conf.percentages:
        vs = " "
    
    var spn = 0
    var sp = ""
    
    if conf.numbers:
        spn = lablen - data.label.len() - intToStr(index).len() + 2
        number = &"{cyan}({index}){reset}"
    
    else:        
        spn = lablen - data.label.len() - 1

    for i in 0..spn:
        sp.add(" ")
    
    echo &"{number}{sp}{data.label} {line}{ps}{value}{vs}{percentage}{reset}"

# After getting the data and config
# perform all bar operations
proc show_bars*(conf: Config) = 
    var data = conf.data.sortedByIt(it.amount)
    if conf.reverse:
        data.reverse()
    let lablen = max_label(data)
    let highest = highest_amount(data)
    var index = 1
    if conf.nreverse:
        index = data.len()
    for i, d in data:
        bar(d, lablen, highest, conf, index)
        if conf.spacing and i < data.len() - 1:
            echo ""
        if conf.nreverse:
            index -= 1
        else:
            index += 1