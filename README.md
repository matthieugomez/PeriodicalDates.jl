[![Build Status](https://travis-ci.com/matthieugomez/MonthlyDates.jl.svg?branch=master)](https://travis-ci.com/matthieugomez/MonthlyDates.jl)

# MonthlyDates.jl

This packages makes it easier to work with monthly or quarterly dates. It defines two types:


- A `MonthlyDate <: TimeType` type
	```julia
	julia> using Dates, MonthlyDates
	julia> dt = Date(1990, 1)
	# 1990-01-01
	julia> dtm = MonthlyDate(dt)
	# 1990m01
	# Alternatively, use the MonthlyDate constructor:
	julia> dtm = MonthlyDate(1990, 1)
	# 1990m01
	# Alternatively, contruct from a string using default dateformat "yyyy\mmm"
	julia> dtm = MonthlyDate("1990-1", dateformat"Y-m")
	# 1990m01
	julia> dtm + Month(1)
	# 1990m02
	julia> Date(dtm)
	# 1990-01-01

	```
- A `QuarterlyDate <: TimeType` type

	```julia
	julia> using Dates, MonthlyDates
	julia> dt = Date(1990, 1)
	# 1990-01-01
	julia> dtq = QuarterlyDate(dt)
	# 1990q1
	# Alternatively, use the QuarterlyDate constructor:
	julia> dtq = QuarterlyDate(1990, 1)
	# 1990q1
	# Alternatively, contruct from a string using default dateformat "yyyy\qq"
	julia> dtq = QuarterlyDate("1990q1", dateformat"yyyy\qq") 
	# 1990q1
	julia> dtq + Quarter(3)
	# 1991q4
	julia> Date(dtq)
	# 1990-01-01
	```

Please open an issue or submit a pull request if you need more methods to be defined.