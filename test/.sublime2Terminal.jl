using Test, Dates, MonthlyDates

MonthlyDate(1990, 1)
@test MonthlyDate(1990, 1) + Year(3) == MonthlyDate(1993, 1)
@test MonthlyDate(1990, 1) - Year(3) == MonthlyDate(1987, 1)
@test MonthlyDate(1990, 1) - Month(3) == MonthlyDate(1989, 10)
@test MonthlyDate(1990, 1) + Month(12) == MonthlyDate(1991, 1)
@test MonthlyDate(1990, 1) - Month(12) == MonthlyDate(1989, 1)
@test MonthlyDate(1990, 1) + Month(13) == MonthlyDate(1991, 2)
@test MonthlyDate(1990, 1) - Month(13) == MonthlyDate(1988, 12)
@test MonthlyDate(1990, 1) + Quarter(1) == MonthlyDate(1990, 4)
@test MonthlyDate(1990, 1) - Quarter(1) == MonthlyDate(1989, 10)
QuarterlyDate(1990, 1)
