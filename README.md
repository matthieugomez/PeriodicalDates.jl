[![Build status](https://github.com/matthieugomez/PeriodicalDates.jl/workflows/CI/badge.svg)](https://github.com/matthieugomez/PeriodicalDates.jl/actions)

# PeriodicalDates.jl

This package makes it easier to work with monthly, quarterly, or yearly dates. It defines three `TimeType`s — `MonthlyDate`, `QuarterlyDate`, and `YearlyDate` — that plug into the `Dates` standard library: construction, parsing, formatting, arithmetic, ranges, and plotting.

## Types

### `MonthlyDate`

```julia
using Dates, PeriodicalDates

MonthlyDate(1990, 1)                # from parts
MonthlyDate(Date(1990, 1, 15))      # from a Date/DateTime (the day is dropped)
MonthlyDate("1990-01")              # from a string, default dateformat"yyyy-mm"
MonthlyDate("1990/01", "yyyy/mm")   # from a string, custom format

MonthlyDate(1990, 1) + Month(1)     # 1990-02
Date(MonthlyDate(1990, 1))          # 1990-01-01
```

### `QuarterlyDate`

```julia
using Dates, PeriodicalDates

QuarterlyDate(1990, 1)              # from parts
QuarterlyDate(Date(1990, 4, 15))    # from a Date/DateTime
QuarterlyDate("1990-Q1")            # from a string, default dateformat"yyyy-Qq"
QuarterlyDate("1990/04", "yyyy/mm") # from a string (month is mapped to its quarter)

QuarterlyDate(1990, 1) + Quarter(3) # 1990-Q4
Date(QuarterlyDate(1990, 2))        # 1990-04-01
```

### `YearlyDate`

```julia
using Dates, PeriodicalDates

YearlyDate(1990)
YearlyDate(1990) + Year(1)          # 1991
Date(YearlyDate(1990))              # 1990-01-01
```

## Accessors

```julia
year(MonthlyDate(1990, 3))                # 1990
month(MonthlyDate(1990, 3))               # 3
quarterofyear(MonthlyDate(1990, 3))       # 1
quarter(QuarterlyDate(1990, 2))           # 2

firstdayofmonth(MonthlyDate(1990, 3))     # 1990-03-01
lastdayofmonth(MonthlyDate(2000, 2))      # 2000-02-29
firstdayofquarter(QuarterlyDate(1990, 2)) # 1990-04-01
lastdayofquarter(QuarterlyDate(1990, 2))  # 1990-06-30
```

## Conversions between types

The three types convert into one another and into `Date`/`DateTime`. A coarser-to-finer conversion lands on the first sub-period:

```julia
QuarterlyDate(MonthlyDate(1990, 5))  # 1990-Q2
YearlyDate(QuarterlyDate(1990, 3))   # 1990
MonthlyDate(QuarterlyDate(1990, 2))  # 1990-04   (first month of the quarter)
```

## Ranges

```julia
range(MonthlyDate(1990, 1), MonthlyDate(1991, 1), step = Month(3))      # length 5
range(QuarterlyDate(1990, 1), QuarterlyDate(1991, 1), step = Quarter(1)) # length 5
range(YearlyDate(1990), YearlyDate(1995), step = Year(1))               # length 6
```

## Notes

- Comparisons across types follow the `Dates` promotion rules, e.g. `MonthlyDate(1990, 1) == Date(1990, 1, 1)` is `true`. As in the standard library (`Date` vs `DateTime`), equal values of *different* types do not share a hash, so mixing types as `Dict`/`Set` keys is not supported.

Please open an issue or submit a pull request if you need more methods to be defined.

This package was formerly registered under the name MonthlyDates.jl.
