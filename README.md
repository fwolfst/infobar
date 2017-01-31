# Infobar

## Description

Display progress of computations and additional information to the terminal.

## Installation

    # gem install infobar

## Usage

    > Infobar(total: 23)
    ░░░░░░░░░░ Infobar 6/23 in 00:00:05, ETA 00:00:17 @17:43:37 –
    > 23.times { +infobar; sleep 1 }
    ░░░░░░░░░░░Infobar 23/23 in 00:00:22, ETA 00:00:00 @17:43:37 ✓░░░░░░░░░░ 

    or alternatively

    > (1..23).with_infobar.each { |i| +infobar; sleep 1 }

## Changes

* 2017-02-08 Release 0.0.0

## Download

The homepage of this library is located at

* https://github.com/flori/infobar

## Author

[Florian Frank](mailto:flori@ping.de)

## License

This software is licensed under the Apache 2.0 license.
