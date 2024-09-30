# Bitcoin Block Arrival Time Dataset for testnet4

A dataset of block arrival times as seen by multiple nodes on the Bitcoin Network.

## Dataset

The dataset is split over multiple CSV files in the `data` directory. One CSV
file per source. Each file contains the block `height`, the header `hash`, the
millisecond `timestamp` the block arrived/was first connected at the node. The
CVS files do not have a header.

Example:
```
47342,000000008ccc9d998b48eea331ef063fdd2dd5f0a03fa6f6b720eb98b237dd3c,1727395504000
47343,00000000fabed5d52cd34210bda79b289789ecac8e1cf12329f8cbeb82687d96,1727395601000
47344,000000000000001550a2beec1ed384ca179986dba7b4f947754369374bab608a,1727395957000
```

The sources can be combined into one, multi-source CSV file with the Python
script `contrib/combine.py`.

## Adding Data

To add your block arrival times, create a CSV file with the above format in
the data directory. Make sure the timestamps are in millisecond precision.
Also, remember to update the data-availability graph (see below).

Block arrival timestamps can be parsed from the Bitcoin Core `debug.log`.
A Python tool is provided under `contrib/process-debug-log.py`. This expects
a `debug.log` as input file, and a CSV file output name.

```
python3 contrib/process-debug-log.py /home/b10c/.bitcoin/debug.log data/my-timestamps.csv
```

## Quality Assurance

The dataset is run through automatic quality assurance checks in the CI.
There is a check for the arrival timestamps. We assume these should be
either two hours before or after the block header timestamp. For this, we
maintain a list of height and header timestamps in
"qa/block-timestamps/block-timestamps.csv". When adding new timestamps, the
list might need to be updated. This can be done with the Bash script
"qa/block-timestamps/update-block-timestamps.sh" requiring a Bitcoin Core
instance with the REST server enabled.

The following availability graph can be generated with the tool
`qa/data-availability/gen-mermaid.py`. This should be updated when adding a
new data source.

```mermaid
gantt
dateFormat x
title data availability (not showing potential per-source holes)
todayMarker off

achow101: 1723221789409, 1727459182035
sjors: 1725381835000, 1727426895000

```
