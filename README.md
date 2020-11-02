[![Build Status](https://travis-ci.com/matthieugomez/MonthlyDates.jl.svg?branch=master)](https://travis-ci.com/matthieugomez/MonthlyDates.jl)

# MonthlyDates.jl

This packages makes it easier to work with monthly or quarterly dates. It defines two types:


- A `MonthlyDate <: TimeType` type
	```julia
	julia> using Dates, MonthlyDates
	julia> dt = Date(1990, 1)
	# 1990-01-01
	julia> dtm = MonthlyDate(dt)
	# 1990-01
	# Alternatively, use the MonthlyDate constructor:
	julia> dtm = MonthlyDate(1990, 1)
	# 1990-01
	# Alternatively, use a string with a DateFormat (default to ISODateFormat)
	julia> dtm = MonthlyDate("1990-1", dateformat"Y-m")
	# 1990-01
	julia> dtm + Month(1)
	# 1990-02
	julia> Date(dtm)
	# 1990-01-01

	```
- A `QuarterlyDate <: TimeType` type

	```julia
	julia> using Dates, MonthlyDates
	julia> dt = Date(1990, 1)
	# 1990-01-01
	julia> dtq = QuarterlyDate(dt)
	# 1990-Q1
	# Alternatively, use the QuarterlyDate constructor:
	julia> dtq = QuarterlyDate(1990, 1)
	# 1990-Q1
	# Alternatively, use a string with a DateFormat (default to ISODateFormat)
	julia> QuarterlyDate("1990-4","Y-m") 
	# 1990-Q2
	# You can use the q letter to specify quarters:
	julia> dtq = QuarterlyDate("1990-1", "Y-q")
	# 1990-Q1
	julia> dtq + Quarter(3)
	# 1990-Q4
	julia> Date(dtq)
	# 1990-01-01
	```

Please open an issue or submit a pull request if you need more methods to be defined.