module MonthlyDates
    using Printf
    using Dates
    import Dates: UTInstant, value, quarterofyear, DatePart
    using RecipesBase: RecipesBase, @recipe
    # Quarter defined in Julia 1.6
    if isdefined(Dates, :Quarter)
        import Dates: Quarter
    else
        include("Quarter.jl")
    end


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
    MonthlyDate(y::Year, m::Month = Month(1)) = MonthlyDate(value(y), value(m))
    MonthlyDate(y, m = 1) = MonthlyDate(Int64(y), Int64(m))

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

    Dates.eps(::Type{MonthlyDate}) = Month(1)
    Dates.zero(::Type{MonthlyDate}) = Month(0)

    #accessor (only bigger periods)    
    Dates.month(dt::MonthlyDate) = 1 + rem(value(dt) - 1, 12)
    quarterofyear(dt::MonthlyDate) = quarterofyear(Date(dt))
    Dates.year(dt::MonthlyDate) =  1 + div(value(dt) - 1, 12)

    Dates.Month(dt::MonthlyDate) = Month(month(dt))
    Quarter(dt::MonthlyDate) = Quarter(quarterofyear(dt))
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
    function Base.parse(::Type{MonthlyDate}, s::AbstractString, df::DateFormat)
        MonthlyDate(parse(Date, s, df))
    end
    const MonthlyFormat = dateformat"yyyy-mm"
    Dates.default_format(::Type{MonthlyDate}) = MonthlyFormat

    function MonthlyDate(d::AbstractString, format::AbstractString; 
        locale::Dates.Locale = Dates.ENGLISH)
        parse(MonthlyDate, d, DateFormat(format, locale))
    end

    function MonthlyDate(d::AbstractString, format::DateFormat = ISODateFormat)
        parse(MonthlyDate, d, format)
    end

    function Base.print(io::IO, dt::MonthlyDate)
        y,m = yearmonth(dt)
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        mm = lpad(m, 2, "0")
        print(io, "$(yy)-$mm")
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

    #Plot
    # Issue is that I would like to choose ticks myself. Or at least convert depending on whether all ticks are Integer or not, which is not possible
    @recipe function f(::Type{MonthlyDate}, dt::MonthlyDate)
	   (value, dt -> string(MonthlyDate(UTm(round(dt)))))
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
    QuarterlyDate(y::Year, q::Quarter = Quarter(1)) = QuarterlyDate(value(y), value(q))
    QuarterlyDate(y, q = 1) = QuarterlyDate(Int64(y), Int64(q))

    """
    `QuarterlyDate(dt::Date) -> QuarterlyDate`
    
    Convert a `Date` to a `QuarterlyDate`
    """
    QuarterlyDate(dt::TimeType) = convert(QuarterlyDate, dt)
    Base.convert(::Type{QuarterlyDate}, dt::MonthlyDate) = QuarterlyDate(UTQ(((value(dt) - 1) ÷ 3 + 1)))
    Base.convert(::Type{QuarterlyDate}, dt::Date) = QuarterlyDate(year(dt), quarterofyear(dt))
    Base.convert(::Type{QuarterlyDate}, dt::DateTime) = QuarterlyDate(year(dt), quarterofyear(dt))
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

    Dates.eps(::Type{QuarterlyDate}) = Quarter(1)
    Dates.zero(::Type{QuarterlyDate}) = Quarter(0)

    #accessor (only bigger periods)
    Dates.month(dt::QuarterlyDate) = 3 * (quarterofyear(dt) - 1) + 1
    quarterofyear(dt::QuarterlyDate) = quarterofyear(Date(dt))
    Dates.year(dt::QuarterlyDate) = 1 + div(value(dt) - 1, 4)
    Quarter(dt::QuarterlyDate) = Quarter(quarterofyear(dt))
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
    function Dates.tryparsenext(d::DatePart{'q'}, str, i, len)
        return Dates.tryparsenext_base10(str, i, len, Dates.min_width(d), Dates.max_width(d))
    end

    function Dates.format(io, d::DatePart{'q'}, dt)
        print(io, string(quarterofyear(dt)))
    end

    function parse_quarterly(str::AbstractString)
        if occursin('Q', str) # if the string has 'Q', try the default format "2018-Q1"
            parse_quarterly(str, QuarterlyFormat) 
        else # else assume it's formatted as Date
            parse_quarterly(str, ISODateFormat)
        end
    end

    function parse_quarterly(str::AbstractString, df::T) where {T<:DateFormat}
        if Dates.DatePart{'q'} ∉ Dates._directives(T) # if 
            return QuarterlyDate(parse(Date, str, df))
        else
            return parse(QuarterlyDate, str, df)
        end
    end

    # the new key 'q' to Dates.CONVERSION_SPECIFIERS not added during precompilation
    # therefore construction of QuarterlyFormat with from dateformat string will fail
    # manually construct QuarterlyFormat
    const QuarterlyFormat = DateFormat{Symbol("yyyy-Qm"), Tuple{Dates.DatePart{'y'}, Dates.Delim{String, 2}, Dates.DatePart{'q'}}}(
        (
            Dates.DatePart{'y'}(4,false), Dates.Delim{String,2}("-Q"), Dates.DatePart{'q'}(1, false)), 
            Dates.ENGLISH
        )
    Dates.default_format(::Type{QuarterlyDate}) = QuarterlyFormat

    function QuarterlyDate(d::AbstractString, format::AbstractString; 
        locale::Dates.Locale = Dates.ENGLISH)
        parse_quarterly(d, DateFormat(format, locale))
    end

    QuarterlyDate(d::AbstractString, format::DateFormat) = parse_quarterly(d, format)
    QuarterlyDate(d::AbstractString) = parse_quarterly(d)

    function Base.print(io::IO, dt::QuarterlyDate)
        y,m = yearmonth(dt)
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        q = (m - 1) ÷ 3 + 1
        print(io, "$(yy)-Q$q")
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

    #Plot
    @recipe function f(::Type{QuarterlyDate}, x::QuarterlyDate)
        (value, dt -> string(QuarterlyDate(UTQ(round(dt)))))
    end

    export MonthlyDate, QuarterlyDate

    # executed at runtime to avoid issues with precompiling dicts
    function __init__()
        Dates.CONVERSION_SPECIFIERS['q'] = Quarter
        Dates.CONVERSION_DEFAULTS[Quarter] = Int64(1)
        Dates.CONVERSION_TRANSLATIONS[QuarterlyDate] = (Year, Quarter)
    end

end