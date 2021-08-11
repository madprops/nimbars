import structs
import strutils
import nap

proc get_config*(): Config =
    let source = add_arg(name="source", kind="argument", value="Path of the data file", required=true, help="Path to the data file")
    let symbol = add_arg(name="symbol", kind="value", value="=", help="Symbol used for the bars")
    let start_symbol = add_arg(name="start-symbol", kind="value", help="Symbol at the start of bars")
    let end_symbol = add_arg(name="end-symbol", kind="value", help="Symbol at the end of bars")
    let density = add_arg(name="density", kind="value", value="2.5", help="The width of the bars")
    let reverse = add_arg(name="reverse", kind="flag", help="Reverse data order")
    let nreverse = add_arg(name="nreverse", kind="flag", help="Reverse rank numbers")
    let no_padding = add_arg(name="no-padding", kind="flag", help="Don't use padding")
    let no_colors = add_arg(name="no-colors", kind="flag", help="Don't use colors")
    let no_values = add_arg(name="no-values", kind="flag", help="Don't show values")
    let numbers = add_arg(name="numbers", kind="flag", help="Show rank numbers")
    let spacing = add_arg(name="spacing", kind="flag", help="Use extra spacing")
    let no_percentages = add_arg(name="no-percentages", kind="flag", help="Don't show percentages")

    parse_args()

    # Read file
    let fcontent = readfile(source.value).strip()
    let split = fcontent.splitLines()
    var dlines: seq[string]
    var title = ""
    var units = ""

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
        data.add(Data(label:d[0..^2].join(" ").strip(), amount:parseFloat(d[^1])))

    # Return the config object
    Config(
        data: data, 
        title: title, 
        units: units, 
        source: source.value, 
        density: density.getFloat(), 
        symbol: symbol.value, 
        start_symbol: start_symbol.value, 
        end_symbol: end_symbol.value,
        reverse: reverse.used, 
        nreverse: nreverse.used, 
        colors: not no_colors.used, 
        padding: not no_padding.used, 
        values: not no_values.used, 
        percentages: not no_percentages.used, 
        numbers: numbers.used, 
        spacing: spacing.used
    )