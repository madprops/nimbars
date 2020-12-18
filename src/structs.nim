type Data* = object
    label*: string
    amount*: float

type Config* = object
    data*: seq[Data]
    title*: string
    units*: string
    source*: string
    symbol*: string
    start_symbol*: string
    end_symbol*: string
    density*: float
    reverse*: bool
    nreverse*: bool
    padding*: bool
    colors*: bool
    values*: bool
    percentages*: bool
    numbers*: bool
    spacing*: bool