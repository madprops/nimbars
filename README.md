![](https://i.imgur.com/mUL9pTr.jpg)

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