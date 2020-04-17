module MonthlyDates
    using Dates
    import Dates: UTInstant, value
    using Printf

    include("Quarter.jl")

    ##############################################################################
    ##
    ## MonthlyDate
    ##
    ##############################################################################
    """
    `MonthlyDate`

    `MonthlyDate` wraps a `UTInstant{Month}` and interprets it according to the proleptic
    Gregorian calendar.
    """
    struct MonthlyDate <: TimeType
    	instant::UTInstant{Month}
        MonthlyDate(v::UTInstant{Month}) = new(v)
    end
    UTm(x) = UTInstant(Month(x))

    """
    `MonthlyDate(y, [m]) -> MonthlyDate`

    Construct a `MonthlyDate` type by parts.
    """
    MonthlyDate(y::Int, m::Int = 1) = MonthlyDate(UTm(12 * (y - 1) + m))

    """
    `MonthlyDate(dt::Date) -> MonthlyDate`
    
    Convert a `Date` to a `MonthlyDate`
    """
    MonthlyDate(dt::TimeType) = convert(MonthlyDate, dt)

    Base.convert(::Type{MonthlyDate}, dt::Date) = MonthlyDate(yearmonth(dt)...)
    Base.convert(::Type{MonthlyDate}, dt::DateTime) = MonthlyDate(yearmonth(dt)...)
    Base.convert(::Type{MonthlyDate}, x::Month) = MonthlyDate(UTInstant(x))

    Dates.yearmonth(dt::MonthlyDate) =  (1, 1) .+ divrem(value(dt) - 1, 12)
    Base.convert(::Type{Date}, dt::MonthlyDate) = Date(yearmonth(dt)...)
    Base.convert(::Type{DateTime}, dt::MonthlyDate) = DateTime(yearmonth(dt)...)
    Base.convert(::Type{Month}, dt::MonthlyDate) = Month(value(dt))
    Base.promote_rule(::Type{MonthlyDate}, x::Type{Date}) = Date
    Base.promote_rule(::Type{MonthlyDate}, x::Type{DateTime}) = DateTime   

    #accessor
    Dates.day(dt::MonthlyDate) = day(Date(dt))
    Dates.week(dt::MonthlyDate) = week(Date(dt))
    Dates.month(dt::MonthlyDate) = 1 + rem(value(dt) - 1, 12)
    quarter(dt::MonthlyDate) = quarter(Date(dt))
    Dates.year(dt::MonthlyDate) =  1 + div(value(dt) - 1, 12)

    Dates.Day(dt::MonthlyDate) = Day(day(dt))
    Dates.Week(dt::MonthlyDate) = Week(week(dt))
    Dates.Month(dt::MonthlyDate) = Month(month(dt))
    Quarter(dt::MonthlyDate) = Quarter(quarter(dt))
    Dates.Year(dt::MonthlyDate) = Year(year(dt))

    # arithmetics
    Base.:+(dt::MonthlyDate, m::Month) = MonthlyDate(UTm(value(dt) + value(m)))
    Base.:-(dt::MonthlyDate, m::Month) = MonthlyDate(UTm(value(dt) - value(m)))
    Base.:+(dt::MonthlyDate, p::Quarter) = dt + Month(p)
    Base.:-(dt::MonthlyDate, p::Quarter) = dt - Month(p)
    Base.:+(dt::MonthlyDate, p::Year) = dt + Month(p)
    Base.:-(dt::MonthlyDate, p::Year) = dt - Month(p)
  
    # range
    months(dt::Month) = value(dt)
    months(dt::Quarter) = 4 * value(dt)
    months(dt::Year) = 12 * value(dt)
    Dates.guess(a::MonthlyDate, b::MonthlyDate, c) = Int64(div(value(b - a), months(c)))

    # io
    function Base.print(io::IO, dt::MonthlyDate)
        y,m = yearmonth(dt)
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        mm = lpad(m, 2, "0")
        print(io, "$(yy)m$mm")
    end
    Base.show(io::IO, ::MIME"text/plain", dt::MonthlyDate) = print(io, dt)
    Base.show(io::IO, dt::MonthlyDate) = print(io, typeof(dt), "(\"", dt, "\")")

    ##############################################################################
    ##
    ## QuarterlyDate
    ##
    ##############################################################################
    """
    QuarterlyDate

    QuarterlyDate wraps a UTInstant{Quarter} and interprets it according to the proleptic
    Gregorian calendar.
    """
    struct QuarterlyDate <: TimeType
    	instant::UTInstant{Quarter}
        QuarterlyDate(v::UTInstant{Quarter}) = new(v)
    end
    UTQ(x) = UTInstant(Quarter(x))

    """
    `QuarterlyDate(y, [q]) -> QuarterlyDate`
    
    Construct a `QuaterlyDate` type by parts.
    """
    QuarterlyDate(y::Int, q::Int = 1) = QuarterlyDate(UTQ(4 * (y - 1) + q))

    """
    `QuarterlyDate(dt::Date) -> QuarterlyDate`
    
    Convert a `Date` to a `QuarterlyDate`
    """
    QuarterlyDate(dt::TimeType) = convert(QuarterlyDate, dt)
    Base.convert(::Type{QuarterlyDate}, dt::MonthlyDate) = QuarterlyDate(UTQ(((value(dt) - 1) ÷ 3 + 1)))
    Base.convert(::Type{QuarterlyDate}, dt::Date) = QuarterlyDate(year(dt), quarter(dt))
    Base.convert(::Type{QuarterlyDate}, dt::DateTime) = QuarterlyDate(year(dt), quarter(dt))
    Base.convert(::Type{QuarterlyDate}, x::Quarter) = QuarterlyDate(UTInstant(x))

    function Dates.yearmonth(dt::QuarterlyDate)
        y, q = divrem(value(dt) - 1, 4)
        return 1 + y, 1 + q * 3
    end

    Base.convert(::Type{MonthlyDate}, dt::QuarterlyDate) = MonthlyDate(UTm(((value(dt) - 1) * 3 + 1)))
    Base.convert(::Type{Date}, dt::QuarterlyDate) = Date(yearmonth(dt)...)
    Base.convert(::Type{DateTime}, dt::QuarterlyDate) = DateTime(yearmonth(dt)...)
    Base.convert(::Type{Quarter}, dt::QuarterlyDate) =  Quarter(value(dt))

    Base.promote_rule(::Type{QuarterlyDate}, x::Type{MonthlyDate}) = MonthlyDate
    Base.promote_rule(::Type{QuarterlyDate}, x::Type{Date}) = Date
    Base.promote_rule(::Type{QuarterlyDate}, x::Type{DateTime}) = DateTime   

    #accessor
    Dates.day(dt::QuarterlyDate) = day(Date(dt))
    Dates.week(dt::QuarterlyDate) = week(Date(dt))
    Dates.month(dt::QuarterlyDate) = 1 + rem(value(dt) - 1, 4) * 3
    quarter(dt::QuarterlyDate) = quarter(Date(dt))
    Dates.year(dt::QuarterlyDate) = 1 + div(value(dt) - 1, 4)

    Dates.Day(dt::QuarterlyDate) = Day(day(dt))
    Dates.Week(dt::QuarterlyDate) = Week(week(dt))
    Dates.Month(dt::QuarterlyDate) = Month(month(dt))
    Quarter(dt::QuarterlyDate) = Quarter(quarter(dt))
    Dates.Year(dt::QuarterlyDate) = Year(year(dt))

    # arithmetics
    Base.:+(dt::QuarterlyDate, q::Quarter) = QuarterlyDate(UTQ(value(dt) + value(q)))
    Base.:-(dt::QuarterlyDate, q::Quarter) = QuarterlyDate(UTQ(value(dt) - value(q)))
    Base.:+(dt::QuarterlyDate, p::Year) = dt + Quarter(p)
    Base.:-(dt::QuarterlyDate, p::Year) = dt - Quarter(p)

    # range
    quarters(dt::Quarter) = value(dt)
    quarters(dt::Year) = 4 * value(dt)
    Dates.guess(a::QuarterlyDate, b::QuarterlyDate, c) = Int64(div(value(b - a), quarters(c)))

    # io
    function Base.print(io::IO, dt::QuarterlyDate)
        y,m = yearmonth(dt)
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        q = (m - 1) ÷ 3 + 1
        print(io, "$(yy)q$q")
    end
    Base.show(io::IO, ::MIME"text/plain", dt::QuarterlyDate) = print(io, dt)
    Base.show(io::IO, dt::QuarterlyDate) = print(io, typeof(dt), "(\"", dt, "\")")

    export quarter, Quarter, MonthlyDate, QuarterlyDate

end
