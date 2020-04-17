module MonthlyDates
    using Dates
    import Base: +, -
    import Dates: UTInstant, value, Date, days
    using Printf

    include("Quarter.jl")

    struct MonthlyDate <: TimeType
    	instant::UTInstant{Month}
        MonthlyDate(v::UTInstant{Month}) = new(v)
    end
    UTm(x) = UTInstant(Month(x))
    function MonthlyDate(y::Int, m::Int = 1)
    	return MonthlyDate(UTm(12 * (y - 1) + m))
    end

    function days(dt::MonthlyDate)
        days(convert(Date, dt))
    end

    function (+)(dt::MonthlyDate, m::Month)
        oy, om = yearmonth(dt)
        y, m = divrem(om + value(m), 12)
        MonthlyDate(oy + y, m)
    end
    (+)(dt::MonthlyDate, p::Year) = dt + Month(p)

    function (-)(dt::MonthlyDate, m::Month)
        oy, om = yearmonth(dt)
        y, m = divrem(om - value(m), 12)
        MonthlyDate(oy + y - 1, 12 + m)
    end
    (-)(dt::MonthlyDate, p::Year) = dt - Month(p)
  
    function Base.convert(::Type{MonthlyDate}, dt::Date)
      MonthlyDate(yearmonth(dt)...)
    end
    function Base.convert(::Type{Date}, dt::MonthlyDate)
    	Date(1, 1, 1) + dt.instant.periods - Month(1)
    end

    MonthlyDate(dt::TimeType) = convert(MonthlyDate, dt)
    
    function Base.print(io::IO, dt::MonthlyDate)
        y,m = yearmonth(days(dt))
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        mm = lpad(m, 2, "0")
        print(io, "$(yy)m$mm")
    end


    struct QuarterlyDate <: TimeType
    	instant::UTInstant{Quarter}
        QuarterlyDate(v::UTInstant{Quarter}) = new(v)
    end
    UTQ(x) = UTInstant(Quarter(x))
    function QuarterlyDate(y::Int, q::Int = 1)
        return QuarterlyDate(UTQ(4 * (y -1) + q))
    end

    function days(dt::QuarterlyDate)
        days(Date(dt))
    end

    function (+)(dt::QuarterlyDate, q::Quarter)
        oy = year(dt)
        oq = quarter(dt)
        y, q = divrem(oq + value(q), 4)
        QuarterlyDate(oy + y, q)
    end
    (+)(dt::QuarterlyDate, p::Period) = dt + Quarter(p)

    function (-)(dt::QuarterlyDate, q::Quarter)
        oy = year(dt)
        oq = quarter(dt)
        y, q = divrem(oq - value(q), 4)
        QuarterlyDate(oy + y - 1, 4 + q)
    end
    (-)(dt::QuarterlyDate, p::Period) = dt - Quarter(p)

 
    function Base.convert(::Type{QuarterlyDate}, dt::Date)
        QuarterlyDate(year(dt), quarter(dt))
    end
    function Base.convert(::Type{Date}, dt::QuarterlyDate)
    	Date(1, 1, 1) + dt.instant.periods - Quarter(1)
    end

    function Base.convert(::Type{QuarterlyDate}, dt::MonthlyDate)
        QuarterlyDate(UTQ((value(dt) - 1) ÷ 3 + 1))
    end
    function Base.convert(::Type{MonthlyDate}, dt::QuarterlyDate)
        MonthlyDate(UTm((value(dt) -1) * 3 + 1))
    end

    QuarterlyDate(dt::TimeType) = convert(QuarterlyDate, dt)


    function Base.print(io::IO, dt::QuarterlyDate)
    	y,m = yearmonth(days(dt))
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        q = (m - 1) ÷ 3 + 1
        print(io, "$(yy)q$q")
    end


    for date_type in (:MonthlyDate, :QuarterlyDate)
        # Human readable output (i.e. "2012-01-01")
        @eval Base.show(io::IO, ::MIME"text/plain", dt::$date_type) = print(io, dt)
        # Parsable output (i.e. Date("2012-01-01"))
        @eval Base.show(io::IO, dt::$date_type) = print(io, typeof(dt), "(\"", dt, "\")")
        # Parsable output will have type info displayed, thus it is implied
        @eval Base.typeinfo_implicit(::Type{$date_type}) = true
    end

    export quarter, Quarter, MonthlyDate, QuarterlyDate

end
