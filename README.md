[![Build Status](https://travis-ci.com/matthieugomez/MonthlyDates.jl.svg?branch=master)](https://travis-ci.com/matthieugomez/MonthlyDates.jl)
[![Coverage Status](https://coveralls.io/repos/matthieugomez/MonthlyDates.jl/badge.svg?branch=master)](https://coveralls.io/r/matthieugomez/MonthlyDates.jl?branch=master)

# MonthlyDates.jl

This packages makes it easier to work with monthly or quarterly dates. It defines two types:


- A `MonthlyDate <: TimeType` type
	```julia
	julia> using Dates, MonthlyDates
	julia> dt = MonthlyDate(1990, 1)
	# Alternatively, construct from a date
	julia> dtm = MonthlyDate(Date(1990, 1))
	# Alternatively, contruct from a string with default dateformat"yyyy-mm"
	julia> dtm = MonthlyDate("1990-01")
	# or any other DateFormat
	julia> dtm = MonthlyDate("1990/01", "yyyy/mm")
	# Arithmetic works as expected
	julia> dtm + Month(1)
	julia> Date(dtm)
	# 1990-01-01

	```
- A `QuarterlyDate <: TimeType` type

	```julia
	julia> using Dates, MonthlyDates
	julia> dtq = QuarterlyDate(1990, 1)
	# Alternatively, construct from a date
	julia> dtq = QuarterlyDate(Date(1990, 1))
	# Alternatively, contruct from a string with default dateformat"yyyy-Qq"
	julia> dtq = QuarterlyDate("1990-Q1") 
	# or any other DateFormat
	julia> dtq = QuarterlyDate("1990/04", "yyyy/mm")
	# Arithmetic works as expected
	julia> dtq + Quarter(3)
	julia> Date(dtq)
	# 1990-04-01
	```

Please open an issue or submit a pull request if you need more methods to be defined.