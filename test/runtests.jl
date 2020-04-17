using Test

MonthlyDate(1990, 1)
MonthlyDate(1990, 1) + Year(3)
MonthlyDate(1990, 1) - Year(3)
MonthlyDate(1990, 1) + Month(3)
MonthlyDate(1990, 1) - Month(3)
MonthlyDate(1990, 1) + Quarter(1)
MonthlyDate(1990, 1) - Quarter(1)
QuarterlyDate(1990, 1)
QuarterlyDate(1990, 1) + Quarter(1)
3 * Quarter(1)
Month(Quarter(3))
#test_throws
@test_throws InexactError Quarter(Month(4))


MonthlyDate(QuarterlyDate(1990, 1))
QuarterlyDate(MonthlyDate(1990, 1))