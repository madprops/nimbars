type Data* = object
    label*: string
    amount*: float

type Config* = object
    data*: seq[Data]
    source*: string
    title*: string
    units*: string
    symbol*: string
    colors*: bool
    reverse*: bool
    nreverse*: bool
    padding*: bool
    values*: bool
    percentages*: bool
    numbers*: bool
    spacing*: bool