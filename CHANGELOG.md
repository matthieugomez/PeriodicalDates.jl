# Changelog

All notable changes to this package are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the package follows
[semantic versioning](https://semver.org/).

## [2.0.1]

### Fixed
- Accessors (`year`, `month`, `quarter`, `yearmonth`) and conversions between
  `MonthlyDate`, `QuarterlyDate`, and `YearlyDate` now return correct results for
  years `<= 0` (the proleptic calendar). They previously used truncated division,
  which mis-decomposed dates with non-positive internal values (e.g.
  `MonthlyDate(-5, 3)` printed `-0004--9`).
- `show(io, ::YearlyDate)` now prints a reconstructable `YearlyDate("1990")`,
  consistent with `MonthlyDate` and `QuarterlyDate`. It previously printed a bare
  integer, which was ambiguous with `Int` in nested displays.

### Changed
- Added `[compat]` entries for the `Dates` and `Printf` standard libraries.

## [2.0.0]
- Renamed from MonthlyDates.jl. Added `YearlyDate`.
