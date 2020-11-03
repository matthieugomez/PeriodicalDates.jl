[![Build Status](https://travis-ci.com/matthieugomez/MonthlyDates.jl.svg?branch=master)](https://travis-ci.com/matthieugomez/MonthlyDates.jl)
[![Coverage Status](https://coveralls.io/repos/matthieugomez/MonthlyDates.jl/badge.svg?branch=master)](https://coveralls.io/r/matthieugomez/MonthlyDates.jl?branch=master)

# MonthlyDates.jl

This packages makes it easier to work with monthly or quarterly dates. It defines two types:


- A `MonthlyDate <: TimeType` type
	```julia
	julia> using Dates, MonthlyDates
	julia> dt = MonthlyDate(1990, 1)
	# 1990-01
	# Alternatively, construct from a date
	julia> dtm = MonthlyDate(Date(1990, 1))
	# 1990-01
	# Alternatively, contruct from a string with default dateformat"yyyy-mm"
	julia> dtm = MonthlyDate("1990-01")
	# 1990-01
	julia> dtm = MonthlyDate("1990m01", dateformat"yyyy\mmm")
	# 1990-01
	julia> dtm + Month(1)
	# 1990-02
	julia> Date(dtm)
	# 1990-01-01

	```
- A `QuarterlyDate <: TimeType` type

	```julia
	julia> using Dates, MonthlyDates
	julia> dtq = QuarterlyDate(1990, 1)
	# 1990-Q1
	# Alternatively, construct from a date
	julia> dtq = QuarterlyDate(Date(1990, 1))
	# 1990-Q1
	# Alternatively, contruct from a string with default dateformat"yyyy-Qq"
	julia> dtq = QuarterlyDate("1990-Q1") 
	# 1990-Q1
	julia> dtq = QuarterlyDate("1990-04", dateformat"yyyy-mm")
	# 1990-Q2
	julia> dtq + Quarter(3)
	# 1991-Q1
	julia> Date(dtq)
	# 1990-04-01
	```

Please open an issue or submit a pull request if you need more methods to be defined.