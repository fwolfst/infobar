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

* 2019-04-11 Release 0.6.1
 - Counter string representation shows results now.

* 2019-01-31 Release 0.6.0
 - Allow progressing with - as false.

* 2018-11-01 Release 0.5.1
  - Allow busy bar message to be overwritten.

* 2018-03-05 Release 0.5.0
  - Allow counter values to be formatted with units.

* 2017-12-08 Release 0.4.0
  - Automatically iterate when `with_infobar` is passed a block.

* 2017-06-29 Release 0.3.0
  - Nicely format large numbers the Ruby way

* 2017-05-24 Release 0.2.0
  - Allow setting of input/output on initial call.

…

* 2017-03-24 Release 0.0.6
  - Add busybar functionality via Infobar.busy { … } call

* 2017-03-10 Release 0.0.5
  - Always provide a default unit for rate display, 'i/s' for "items per second".

* 2017-03-10 Release 0.0.4
  - Fix problem b/c at the beginning there might not be a valid rate.

* 2017-03-09 Release 0.0.3
  - Reset frequency after calling clear. This means after calling output methods
  the next update will be forced.

* 2017-02-10 Release 0.0.2
  - Add trend arrow to rate directive

* 2017-02-08 Release 0.0.1
  - Allow disabling of delegated output via infobar.show = false

* 2017-02-08 Release 0.0.0
  - Initial release

## Download

The homepage of this library is located at

* https://github.com/flori/infobar

## Author

[Florian Frank](mailto:flori@ping.de)

## License

This software is licensed under the Apache 2.0 license.
