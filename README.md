![](http://i.imgur.com/8w6Qkrk.jpg)

# Options

```
--symbol=@
How to fill the bars

--no-colors
Don't use colors

--reverse
Reverse from asc to desc

--no-padding
Don't print spaces at top and bottom

--no-values
Don't show the values

--no-percentages
Don't show the percentages

--numbers
Number the bars

--nreverse
Reverse numbers from asc to desc

--spacing
Print a space between each bar

--density=0.8
Lower number means longer bars
```

nimbars reads from a data file. It can look like this:

```
title: Performance (Bigger is better)
units: IPC
AMD 89.384
Intel 75.475
ARM 69.384
RISC-V 58.395
```

There are special metadata settings like title and units. These can be omitted.

The rest are data units in the form of "label amount".

Lines can be commented out if they start with a #

Usage: `nimbars mydata.txt [options]`