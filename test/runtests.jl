using Test, Dates, MonthlyDates

replstr(x, kv::Pair...) = sprint((io,x) -> show(IOContext(io, :limit => true, :displaysize => (24, 80), kv...), MIME("text/plain"), x), x)

##############################################################################
##
## Quarter
##
##############################################################################

@test Quarter(Date(1990, 1)) == Quarter(1)
@test quarterofyear(Date(1990, 1)) == 1
@test Month(Quarter(3)) == Month(9)
@test_throws InexactError Quarter(Month(4))

##############################################################################
##
## MonthlyDate
##
##############################################################################

# since Dates.value(Date(1, 1, 1)) == 1
@test Dates.value(MonthlyDate(1, 1)) == 1
@test Dates.value(MonthlyDate(1.0, 1.0)) == 1

@test MonthlyDate(1990, 1) >= MonthlyDate(1989, 1)
@test Date(MonthlyDate(Date(1990, 1))) == Date(1990, 1)
@test Date(MonthlyDate(1990, 1)) == Date(1990, 1)
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
@test Quarter(MonthlyDate(1990, 1)) == Quarter(1)
@test Month(MonthlyDate(1990, 1)) == Month(1)

# arithmetic
@test MonthlyDate(1990, 1) + Year(3) == MonthlyDate(1993, 1)
@test MonthlyDate(1990, 1) - Year(3) == MonthlyDate(1987, 1)
@test MonthlyDate(1990, 1) - Month(3) == MonthlyDate(1989, 10)
@test MonthlyDate(1990, 1) + Month(12) == MonthlyDate(1991, 1)
@test MonthlyDate(1990, 1) - Month(12) == MonthlyDate(1989, 1)
@test MonthlyDate(1990, 1) + Month(13) == MonthlyDate(1991, 2)
@test MonthlyDate(1990, 1) - Month(13) == MonthlyDate(1988, 12)
@test MonthlyDate(1990, 1) + Quarter(1) == MonthlyDate(1990, 4)
@test MonthlyDate(1990, 1) - Quarter(1) == MonthlyDate(1989, 10)
@test MonthlyDate(1990, 1) - MonthlyDate(1989, 1) == Month(12)
@test MonthlyDate(1990, 1) + Quarter(2) + Month(2) == MonthlyDate(1990, 9)

# ranges
@test length(range(MonthlyDate(1990, 1), MonthlyDate(1991, 1), step = Month(1))) == 13
@test length(range(MonthlyDate(1990, 1), MonthlyDate(1991, 1), step = Month(3))) == 5

# print
@test replstr([MonthlyDate(1990, 1)]) == "1-element $(string(Array{MonthlyDate,1})):\n 1990m01"
##############################################################################
##
## QuarterlyDate
##
##############################################################################

@test Dates.value(QuarterlyDate(1, 1)) == 1
@test QuarterlyDate(1990, 1) - QuarterlyDate(1989, 1) == Quarter(4)
@test QuarterlyDate(1990, 1) >= QuarterlyDate(1989, 1)
@test Date(QuarterlyDate(1990, 1)) == Date(1990, 1)
@test QuarterlyDate(Date(1990, 1)) == QuarterlyDate(1990, 1)
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

# accessor
@test year(QuarterlyDate(1990, 4)) == 1990
@test quarterofyear(QuarterlyDate(1990, 4)) == 4

@test Year(QuarterlyDate(1990, 1)) == Year(1990)
@test Quarter(QuarterlyDate(1990, 1)) == Quarter(1)

# arithmetic
@test QuarterlyDate(1990, 1) + Year(1) == QuarterlyDate(1991, 1)
@test QuarterlyDate(1990, 1) - Year(1) == QuarterlyDate(1989, 1)
@test QuarterlyDate(1990, 1) + Quarter(1) == QuarterlyDate(1990, 2)
@test QuarterlyDate(1990, 1) - Quarter(1) == QuarterlyDate(1989, 4)
@test QuarterlyDate(1990, 1) + Year(1) + Quarter(3) == QuarterlyDate(1991, 4)

# ranges
@test length(range(QuarterlyDate(1990, 1), QuarterlyDate(1991, 1), step = Quarter(1))) == 5
@test length(range(QuarterlyDate(1990, 1), QuarterlyDate(1991, 1), step = Quarter(2))) == 3


@test replstr([QuarterlyDate(1990, 1)]) == "1-element $(string(Array{QuarterlyDate,1})):\n 1990q1"
