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

    #accessor (only bigger periods)    
    Dates.month(dt::MonthlyDate) = 1 + rem(value(dt) - 1, 12)
    quarter(dt::MonthlyDate) = quarter(Date(dt))
    Dates.year(dt::MonthlyDate) =  1 + div(value(dt) - 1, 12)

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
    if VERSION >= v"1.5-"
        Base.show(io::IO, dt::MonthlyDate) = print(io, MonthlyDate, "(\"", dt, "\")")
    else
        Base.show(io::IO, dt::MonthlyDate) = print(io, dt)
    end
    if VERSION >= v"1.4-"
        Base.typeinfo_implicit(::Type{MonthlyDate}) = true
    end

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

    #accessor (only bigger periods)
    quarter(dt::QuarterlyDate) = quarter(Date(dt))
    Dates.year(dt::QuarterlyDate) = 1 + div(value(dt) - 1, 4)
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
    if VERSION >= v"1.5-"
        Base.show(io::IO, dt::QuarterlyDate) = print(io, QuarterlyDate, "(\"", dt, "\")")
    else
        Base.show(io::IO, dt::QuarterlyDate) = print(io, dt)
    end
    if VERSION >= v"1.4-"
        Base.typeinfo_implicit(::Type{QuarterlyDate}) = true
    end
    ##############################################################################
    ##
    ## Lag/Lead (experimental)
    ##
    ##############################################################################
    function lag(x::AbstractVector, period = 1, default = missing)
        Union{eltype(x), typeof(default)}[checkbounds(Bool, x, i - period) ? x[i-period] : default for i in eachindex(x)]
    end
    function lead(x::AbstractVector, period = 1, default = missing)
        lag(x, -period, default)
    end


    onestep(x::T) where {T} = onestep(T)
    onestep(::Type{T}) where {T} = oneunit(T)
    onestep(::Type{DateTime}) = Millisecond(1)
    onestep(::Type{Date}) = Day(1)
    onestep(::Type{MonthlyDate}) = Month(1)
    onestep(::Type{QuarterlyDate}) = Quarter(1)

    function lag(x::AbstractVector, dt::AbstractVector, period = onestep(eltype(dt)), default = missing)
        inds = keys(dt)
        dtdict = Dict{eltype(dt),eltype(inds)}()
        for (val, ind) in zip(dt, inds)
             out = get!(dtdict, val, ind)
             out != ind && error("Elements of dt must be distinct")
         end
         Union{eltype(x), typeof(default)}[(i = get(dtdict, v - period, nothing); i !== nothing ? x[i] : default) for v in dt]
    end
    function lead(x::AbstractVector, dt::AbstractVector, period = onestep(eltype(dt)), default = missing)
        lag(x, dt, -period, default)
    end

    export quarter, Quarter, MonthlyDate, QuarterlyDate

end
