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
	# Or it can also be parsed from a string by specifying a DateFormat:
	julia> dtm = MonthlyDate("1990-1", dateformat"Y-m") # the second argument can also be omitted if the string satisifies ISODateFormat
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
	# It can also be constructed from a string, with 'q' as the code for quarter:
	julia> dtq = QuarterlyDate("1990-1", "Y-q")
	# 1990-Q1
	# if the DateFormat doesn't contain 'q', the string will be parsed as Date and then converted to QuarterlyDate
	julia> QuarterlyDate("1990-4","Y-m") 
	# 1990-Q2
	julia> dtq + Quarter(3)
	# 1990-Q4
	julia> Date(dtq)
	# 1990-01-01
	```

Please open an issue or submit a pull request if you need more methods to be defined.