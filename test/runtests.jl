using Test, Dates, CSV, MonthlyDates

replstr(x, kv::Pair...) = sprint((io,x) -> show(IOContext(io, :limit => true, :displaysize => (24, 80), kv...), MIME("text/plain"), x), x)

##############################################################################
##
## MonthlyDate
##
##############################################################################
# constructur
@test_throws ArgumentError MonthlyDate(1, 0)
@test_throws ArgumentError MonthlyDate(1, 13)

# since Dates.value(Date(1, 1, 1)) == 1
@test Dates.value(MonthlyDate(1, 1)) == 1
@test Dates.value(MonthlyDate(1.0, 1.0)) == 1

@test MonthlyDate(1990, 1) >= MonthlyDate(1989, 1)
@test MonthlyDate(Year(1990), Month(1)) >= MonthlyDate(1989, 1)

@test Date(MonthlyDate(Date(1990, 1))) == Date(1990, 1)
@test Date(MonthlyDate(DateTime(1990, 1))) == Date(1990, 1)

@test Date(MonthlyDate(1990, 1)) == Date(1990, 1)
@test DateTime(MonthlyDate(1990, 1)) == DateTime(1990, 1)

@test promote_rule(MonthlyDate, Date) == Date
@test promote_rule(MonthlyDate, DateTime) == DateTime
@test eps(MonthlyDate) == Month(1)
@test zero(MonthlyDate) == Month(0)

# similar definition for convert(Day, Date(1990, 1, 1))
@test convert(Month, MonthlyDate(1990, 1)) == Month(23869)
@test convert(MonthlyDate, Month(23869)) == MonthlyDate(1990, 1)


# promotion rules
@test MonthlyDate(1990, 1) == Date(1990, 1, 1)
@test MonthlyDate(1990, 1) != Date(1990, 1, 2)

# accessor
@test year(MonthlyDate(1990, 12)) == 1990
@test quarterofyear(MonthlyDate(1990, 1)) == 1
@test month(MonthlyDate(1990, 12)) == 12

@test Year(MonthlyDate(1990, 1)) == Year(1990)
if isdefined(Dates, :Quarter)
	@test Quarter(MonthlyDate(1990, 1)) == Quarter(1)
end
@test Month(MonthlyDate(1990, 1)) == Month(1)

@test firstdayofmonth(MonthlyDate(1990, 3)) == Date(1990, 3, 1)
@test lastdayofmonth(MonthlyDate(2000, 2)) == Date(2000, 2, 29)
@test firstdayofquarter(MonthlyDate(2000, 2)) == Date(2000, 1, 1)
@test lastdayofquarter(MonthlyDate(2000, 2)) == Date(2000, 3, 31)
@test monthname(MonthlyDate(2000, 2)) == "February"


# adjusters
@test trunc(MonthlyDate(1990, 5), Year) == MonthlyDate(1990, 1)
if isdefined(Dates, :Quarter)
	@test trunc(MonthlyDate(1990, 5), Quarter) == MonthlyDate(1990, 4)
end
@test trunc(MonthlyDate(1990, 5), Month) == MonthlyDate(1990, 5)


# arithmetic
@test MonthlyDate(1990, 1) + Year(3) == MonthlyDate(1993, 1)
@test MonthlyDate(1990, 1) - Year(3) == MonthlyDate(1987, 1)
@test MonthlyDate(1990, 1) - Month(3) == MonthlyDate(1989, 10)
@test MonthlyDate(1990, 1) + Month(12) == MonthlyDate(1991, 1)
@test MonthlyDate(1990, 1) - Month(12) == MonthlyDate(1989, 1)
@test MonthlyDate(1990, 1) + Month(13) == MonthlyDate(1991, 2)
@test MonthlyDate(1990, 1) - Month(13) == MonthlyDate(1988, 12)
@test MonthlyDate(1990, 1) - MonthlyDate(1989, 1) == Month(12)
if isdefined(Dates, :Quarter)
	@test MonthlyDate(1990, 1) + Quarter(1) == MonthlyDate(1990, 4)
	@test MonthlyDate(1990, 1) - Quarter(1) == MonthlyDate(1989, 10)
	@test MonthlyDate(1990, 1) + Quarter(2) + Month(2) == MonthlyDate(1990, 9)
end

# ranges
@test length(range(MonthlyDate(1990, 1), MonthlyDate(1991, 1), step = Month(1))) == 13
@test length(range(MonthlyDate(1990, 1), MonthlyDate(1991, 1), step = Month(3))) == 5
@test length(range(MonthlyDate(1990, 1), MonthlyDate(1992, 1), step = Year(1))) == 3
if isdefined(Dates, :Quarter)
	@test length(range(MonthlyDate(1990, 1), MonthlyDate(1991, 1), step = Quarter(1))) == 5
end


# print
@test replstr([MonthlyDate(1990, 1)]) == "1-element $(string(Array{MonthlyDate,1})):\n 1990-01"
@test Dates.format(MonthlyDate(1990, 3), dateformat"Y-mm") == "1990-03"


# parse
@test MonthlyDate("1990-01") == MonthlyDate(1990, 1)
@test MonthlyDate("1990/01", "y/m") == MonthlyDate(1990, 1)
@test MonthlyDate("1990m01", dateformat"y\mm") == MonthlyDate(1990, 1)

@test parse(MonthlyDate, "1990-01") == MonthlyDate(1990, 1)
@test parse(MonthlyDate, "1990/01", dateformat"y/m") == MonthlyDate(1990, 1)
@test parse(MonthlyDate, "1990m01", dateformat"y\mm") == MonthlyDate(1990, 1)

@test tryparse(MonthlyDate, "1990-13") == nothing
@test tryparse(MonthlyDate, "1990/01", dateformat"y/m") == MonthlyDate(1990, 1)
@test tryparse(MonthlyDate, "1990m01", dateformat"y\mm") == MonthlyDate(1990, 1)


# csv
io = IOBuffer()
df = (x = [MonthlyDate(1990, 1), MonthlyDate(1990, 2)], )
CSV.write(io, df) 
@test String(take!(io)) == "x\n1990-01\n1990-02\n"
##############################################################################
##
## QuarterlyDate
##
##############################################################################
# constructur

if isdefined(Dates, :Quarter)

	@test_throws ArgumentError QuarterlyDate(1, 0)
	@test_throws ArgumentError QuarterlyDate(1, 5)

	@test Dates.value(QuarterlyDate(1, 1)) == 1
	@test QuarterlyDate(1990, 1) - QuarterlyDate(1989, 1) == Quarter(4)
	@test QuarterlyDate(1990, 1) >= QuarterlyDate(1989, 1)

	@test QuarterlyDate(Year(1990), Quarter(1)) == QuarterlyDate(1990, 1)
	@test QuarterlyDate(1990.0, 1.0) == QuarterlyDate(1990, 1)

	@test Date(QuarterlyDate(1990, 1)) == Date(1990, 1)
	@test DateTime(QuarterlyDate(1990, 1)) == DateTime(1990, 1)
	@test QuarterlyDate(Date(1990, 1)) == QuarterlyDate(1990, 1)
	@test QuarterlyDate(DateTime(1990, 1)) == QuarterlyDate(1990, 1)
	@test QuarterlyDate(Date(1990, 2)) == QuarterlyDate(1990, 1)
	@test DateTime(QuarterlyDate(1990, 1)) == DateTime(1990, 1)
	@test QuarterlyDate(DateTime(1990, 1)) == QuarterlyDate(1990, 1)
	@test QuarterlyDate(DateTime(1990, 2)) == QuarterlyDate(1990, 1)
	@test MonthlyDate(QuarterlyDate(1990, 1)) == MonthlyDate(1990, 1)
	@test QuarterlyDate(MonthlyDate(1990, 1)) == QuarterlyDate(1990, 1)
	# similar definition for convert(Day, Date(1990, 1, 1))
	@test convert(Quarter, QuarterlyDate(1990, 1)) == Quarter(7957)
	@test convert(QuarterlyDate, Quarter(7957)) == QuarterlyDate(1990, 1)


	# promotion rules
	@test QuarterlyDate(1990, 1) != Date(1990, 1, 2)
	@test QuarterlyDate(1990, 1) == MonthlyDate(1990, 1)
	@test QuarterlyDate(1990, 1) != MonthlyDate(1990, 2)
	@test promote_rule(QuarterlyDate, MonthlyDate) == MonthlyDate
	@test promote_rule(QuarterlyDate, Date) == Date
	@test promote_rule(QuarterlyDate, DateTime) == DateTime
	@test eps(QuarterlyDate) == Quarter(1)
	@test zero(QuarterlyDate) == Quarter(0)
	# accessor
	@test year(QuarterlyDate(1990, 4)) == 1990
	@test quarterofyear(QuarterlyDate(1990, 4)) == 4

	@test Year(QuarterlyDate(1990, 1)) == Year(1990)
	@test Quarter(QuarterlyDate(1990, 1)) == Quarter(1)

	@test trunc(QuarterlyDate(1990, 3), Year) == QuarterlyDate(1990, 1)
	@test trunc(QuarterlyDate(1990, 3), Quarter) == QuarterlyDate(1990, 3)

	# adjusters
	@test firstdayofquarter(QuarterlyDate(1990, 3)) == Date(1990, 7, 1)
	@test lastdayofquarter(QuarterlyDate(1990, 3)) == Date(1990, 9, 30)

	# arithmetic
	@test QuarterlyDate(1990, 1) + Year(1) == QuarterlyDate(1991, 1)
	@test QuarterlyDate(1990, 1) - Year(1) == QuarterlyDate(1989, 1)
	@test QuarterlyDate(1990, 1) + Quarter(1) == QuarterlyDate(1990, 2)
	@test QuarterlyDate(1990, 1) - Quarter(1) == QuarterlyDate(1989, 4)
	@test QuarterlyDate(1990, 1) + Year(1) + Quarter(3) == QuarterlyDate(1991, 4)

	# ranges
	@test length(range(QuarterlyDate(1990, 1), QuarterlyDate(1991, 1), step = Quarter(1))) == 5
	@test length(range(QuarterlyDate(1990, 1), QuarterlyDate(1991, 1), step = Quarter(2))) == 3
	@test length(range(QuarterlyDate(1990, 1), QuarterlyDate(1992, 1), step = Year(1))) == 3


	# io
	@test replstr([QuarterlyDate(1990, 1)]) == "1-element $(string(Array{QuarterlyDate,1})):\n 1990-Q1"

	# parse
	@test parse(QuarterlyDate, "1990-07", dateformat"yyyy-mm") == QuarterlyDate(1990, 3)
	@test QuarterlyDate("1990-07", "yyyy-mm") == QuarterlyDate(1990, 3)
	@test parse(QuarterlyDate,"1990-Q2", dateformat"yyyy-Qq") == QuarterlyDate(1990, 2)
	@test tryparse(QuarterlyDate,"1990-Q2", dateformat"yyyy-Qq") == QuarterlyDate(1990, 2)
	@test tryparse(QuarterlyDate,"1990-2", dateformat"yyyy-Qq") == nothing
	@test tryparse(QuarterlyDate,"1990-Q2", dateformat"yyyy-mm") == nothing
	@test QuarterlyDate("1990-Q2") == QuarterlyDate(1990, 2)

	@test QuarterlyDate("1990-Q2", "yyyy-Qq") == QuarterlyDate(1990, 2)
	@test QuarterlyDate("1990/01", "y/m") == QuarterlyDate(1990, 1)
	@test QuarterlyDate("1990m01", dateformat"y\mm") == QuarterlyDate(1990, 1)
	@test QuarterlyDate("1990m07", dateformat"y\mm") == QuarterlyDate(1990, 3)
	@test QuarterlyDate("1990-03", dateformat"y-q") == QuarterlyDate(1990, 3)

	# formater
	@test Dates.format(QuarterlyDate(1990, 3), dateformat"yyyy-Qq") == "1990-Q3"


	# csv
	io = IOBuffer()
	df = (x = [QuarterlyDate(1990, 1), QuarterlyDate(1990, 2)], )
	CSV.write(io, df) 
	@test String(take!(io)) == "x\n1990-Q1\n1990-Q2\n"
end