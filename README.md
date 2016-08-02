# DESCRIPTION

This is a collection of scripts to read data from Brymen multimeters (currently just the BM257s, but all can be adapted).

Sigrok-cli offers csv output, but I've found this output really limited for this kind of multimeters (it just outputs the value). The script adds a timestamp to every reading, and preserves all the info that goes to stdout.

## `sigrok_parser.pl`
This script will read the given input file(s) (or STDIN) of sigrok output format 
for Brymen BM257s, parse it, and write it into a CSV file.

Example of real usage:

```
 $ sigrok-cli --driver=brymen-bm25x:conn=/dev/ttyUSB0 --continuous \ 
    | ./sigrok_parser.p
```

Known formats are:

```
  P1: 0.000000 V DC AUTO
  P1: 0.020000 V AC AUTO
  P1: inf Ω AUTO
  P1: 908000.000000 Ω AUTO
  P1: 0.000000 F AUTO
  P1: inf V DIODE
  P1: 0.659000 V DIODE
```

## `mah_plot.R`
Sample R script to plot the data we got from the multimeter to calculate energy stored on a battery (in mAh).

Filename has to be adapted of course. Also `m_load` and `y_limit` have to be adjusted.
The first one is the constant current discharge you did (in mA) and the later is the low voltage threshold of your battery (in Volts).
