module PeriodicalDates
    using Printf: @sprintf
    using Dates: Dates, TimeType, UTInstant, Year, Month, Day, Date, DateTime, value, DatePart, @dateformat_str, DateFormat, yearmonth, month, year, quarterofyear, lastdayofmonth, firstdayofmonth, firstdayofquarter, lastdayofquarter, quarter, Quarter
    using RecipesBase: @recipe 
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
    UTM(x) = UTInstant(Month(x))
    function Dates.validargs(::Type{MonthlyDate}, y::Int, m::Int)
        1 <= m <= 12 || throw(ArgumentError("Month: $m out of range (1:12)"))
        nothing
    end

    """
    `MonthlyDate(y, [m]) -> MonthlyDate`

    Construct a `MonthlyDate` type by parts. Arguments must be convertible to `Int64`
    """
    function MonthlyDate(y::Int, m::Int = 1)
        Dates.validargs(MonthlyDate, y, m)
        MonthlyDate(UTM(12 * (y - 1) + m))
    end
    MonthlyDate(y::Year, m::Month = Month(1)) = MonthlyDate(value(y), value(m))
    MonthlyDate(y, m = 1) = MonthlyDate(Int64(y), Int64(m))

    """
    `MonthlyDate(dt::Date) -> MonthlyDate`
    Convert a `TimeType` to a `MonthlyDate`
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
   
    #accessors (only bigger periods)    
    Dates.month(dt::MonthlyDate) = 1 + rem(value(dt) - 1, 12)
    Dates.year(dt::MonthlyDate) =  1 + div(value(dt) - 1, 12)
    Dates.quarterofyear(dt::MonthlyDate) = 1 + div(month(dt) - 1, 3)

    Dates.Month(dt::MonthlyDate) = Month(month(dt))
    Dates.Quarter(dt::MonthlyDate) = Quarter(quarterofyear(dt))
    Dates.Year(dt::MonthlyDate) = Year(year(dt))

    Base.trunc(dt::MonthlyDate, ::Type{Year}) = MonthlyDate(year(dt), 1)
    Base.trunc(dt::MonthlyDate, ::Type{Quarter}) = MonthlyDate(year(dt), 1 + 3 * (quarterofyear(dt) - 1))
    Base.trunc(dt::MonthlyDate, ::Type{Month}) = dt

    # adjusters
    Dates.firstdayofquarter(dt::MonthlyDate) = firstdayofquarter(Date(dt))
    Dates.lastdayofquarter(dt::MonthlyDate) = lastdayofquarter(Date(dt))
    Dates.firstdayofmonth(dt::MonthlyDate) = Date(dt)
    Dates.lastdayofmonth(dt::MonthlyDate) = lastdayofmonth(Date(dt))

    # arithmetics
    Base.:+(dt::MonthlyDate, m::Month) = MonthlyDate(UTM(value(dt) + value(m)))
    Base.:-(dt::MonthlyDate, m::Month) = MonthlyDate(UTM(value(dt) - value(m)))
    Base.:+(dt::MonthlyDate, p::Quarter) = dt + Month(p)
    Base.:-(dt::MonthlyDate, p::Quarter) = dt - Month(p)
    Base.:+(dt::MonthlyDate, p::Year) = dt + Month(p)
    Base.:-(dt::MonthlyDate, p::Year) = dt - Month(p)
  
    # range
    function Dates.guess(a::MonthlyDate, b::MonthlyDate, c::Month)
    	Int64(div(value(b - a), value(c)))
    end
    function Dates.guess(a::MonthlyDate, b::MonthlyDate, c::Quarter)
    	Int64(div(value(b - a), 3 * value(c)))
    end
    function Dates.guess(a::MonthlyDate, b::MonthlyDate, c::Year)
    	Int64(div(value(b - a), 12 * value(c)))
    end


    # parse
    const MonthlyDateFormat = dateformat"yyyy-mm"
    Dates.default_format(::Type{MonthlyDate}) = MonthlyDateFormat

    function Base.parse(::Type{MonthlyDate}, s::AbstractString, df::DateFormat = MonthlyDateFormat)
        MonthlyDate(parse(Date, s, df))
    end

    function Base.tryparse(::Type{MonthlyDate}, s::AbstractString, df::DateFormat = MonthlyDateFormat)
        out = tryparse(Date, s, df)
        out === nothing ? nothing : MonthlyDate(out)
    end

    """
    MonthlyDate(d::AbstractString, format::AbstractString; locale="english") -> MonthlyDate

    Construct a `MonthlyDate` by parsing the date string following the pattern given in the
    `format` string.

    This method creates a `DateFormat` object each time it is called. If you are parsing many date strings of the same format, consider creating a `DateFormat` object once and using that as the second argument instead.

    ### Examples
    ```julia
    julia> MonthlyDate("1990-01", "yyy-mm")
    ```
    """
    function MonthlyDate(d::AbstractString, format::AbstractString; 
        locale::Dates.Locale = Dates.ENGLISH)
        parse(MonthlyDate, d, DateFormat(format, locale))
    end

    """
    Monthly Date(d::AbstractString, df::DateFormat) -> MonthlyDate

    Parse a MonthlyDate from a date string `d` using a `DateFormat` object `df`.
    """
    function MonthlyDate(d::AbstractString, format::DateFormat = MonthlyDateFormat)
        parse(MonthlyDate, d, format)
    end

    # show
    function Base.print(io::IO, dt::MonthlyDate)
        y,m = yearmonth(dt)
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        mm = lpad(m, 2, "0")
        print(io, "$(yy)-$mm")
    end
    Base.show(io::IO, ::MIME"text/plain", dt::MonthlyDate) = print(io, dt)
    Base.show(io::IO, dt::MonthlyDate) = print(io, MonthlyDate, "(\"", dt, "\")")
    Base.typeinfo_implicit(::Type{MonthlyDate}) = true

    # plot
    # I would like to choose ticks myself. Or at least convert depending on whether all ticks are Integer or not, which is not possible
    @recipe function f(::Type{MonthlyDate}, dt::MonthlyDate)
        (value, dt -> string(MonthlyDate(UTM(round(dt)))))
    end

    export MonthlyDate

    ##############################################################################
    ##
    ## QuarterlyDate
    ##
    ##############################################################################
    """
    QuarterlyDate

    `QuarterlyDate` wraps a UTInstant{Quarter} and interprets it according to the proleptic
    Gregorian calendar.
    """
    struct QuarterlyDate <: TimeType
    	instant::UTInstant{Quarter}
        QuarterlyDate(v::UTInstant{Quarter}) = new(v)
    end
    UTQ(x) = UTInstant(Quarter(x))
    function Dates.validargs(::Type{QuarterlyDate}, y::Int, q::Int)
        1 <= q <= 4 || throw(ArgumentError("Quarter: $q out of range (1:4)"))
        nothing
    end
    """
    `QuarterlyDate(y, [q]) -> QuarterlyDate`
    
    Construct a `QuaterlyDate` type by parts. Arguments must be convertible to `Int64`
    """
    function QuarterlyDate(y::Int, q::Int = 1)
        Dates.validargs(QuarterlyDate, y, q)
        QuarterlyDate(UTQ(4 * (y - 1) + q))
    end
    QuarterlyDate(y::Year, q::Quarter = Quarter(1)) = QuarterlyDate(value(y), value(q))
    QuarterlyDate(y, q = 1) = QuarterlyDate(Int64(y), Int64(q))

    """
    `QuarterlyDate(dt::TimeType) -> QuarterlyDate`
    
    Convert a `TimeType` to a `QuarterlyDate`
    """
    QuarterlyDate(dt::TimeType) = convert(QuarterlyDate, dt)
    Base.convert(::Type{QuarterlyDate}, dt::MonthlyDate) = QuarterlyDate(UTQ(((value(dt) - 1) ÷ 3 + 1)))
    Base.convert(::Type{QuarterlyDate}, dt::Date) = QuarterlyDate(year(dt), quarterofyear(dt))
    Base.convert(::Type{QuarterlyDate}, dt::DateTime) = QuarterlyDate(year(dt), quarterofyear(dt))
    Base.convert(::Type{QuarterlyDate}, x::Quarter) = QuarterlyDate(UTInstant(x))

    # should not be yearmonth since month of QuarterlyDate not defined
    function yearquarter(dt::QuarterlyDate)
        y, q = divrem(value(dt) - 1, 4)
        return 1 + y, 1 + q
    end
    Base.convert(::Type{MonthlyDate}, dt::QuarterlyDate) = MonthlyDate(UTM(((value(dt) - 1) * 3 + 1)))
    Base.convert(::Type{Date}, dt::QuarterlyDate) = ((y, q) = yearquarter(dt) ; return Date(y, 1 + (q - 1) * 3))
    Base.convert(::Type{DateTime}, dt::QuarterlyDate) = ((y, q) = yearquarter(dt) ; return DateTime(y, 1 + (q - 1) * 3))
    Base.convert(::Type{Quarter}, dt::QuarterlyDate) =  Quarter(value(dt))

    Base.promote_rule(::Type{QuarterlyDate}, x::Type{MonthlyDate}) = MonthlyDate
    Base.promote_rule(::Type{QuarterlyDate}, x::Type{Date}) = Date
    Base.promote_rule(::Type{QuarterlyDate}, x::Type{DateTime}) = DateTime   

    Dates.eps(::Type{QuarterlyDate}) = Quarter(1)
    Dates.zero(::Type{QuarterlyDate}) = Quarter(0)

    #accessors (only bigger periods)
    Dates.year(dt::QuarterlyDate) = 1 + div(value(dt) - 1, 4)
    # important since quarter may not reflect quarter of year actually
    Dates.quarter(dt::QuarterlyDate) = 1 + rem(value(dt) - 1, 4)
    Dates.quarterofyear(dt::QuarterlyDate) = quarter(dt)

    Quarter(dt::QuarterlyDate) = Quarter(quarter(dt))
    Dates.Year(dt::QuarterlyDate) = Year(year(dt))
    Base.trunc(dt::QuarterlyDate, ::Type{Year}) = QuarterlyDate(year(dt), 1)
    Base.trunc(dt::QuarterlyDate, ::Type{Quarter}) = dt

    # adjusters
    Dates.firstdayofquarter(dt::QuarterlyDate) = Date(dt)
    Dates.lastdayofquarter(dt::QuarterlyDate) = lastdayofquarter(Date(dt))
    
    # arithmetics
    Base.:+(dt::QuarterlyDate, q::Quarter) = QuarterlyDate(UTQ(value(dt) + value(q)))
    Base.:-(dt::QuarterlyDate, q::Quarter) = QuarterlyDate(UTQ(value(dt) - value(q)))
    Base.:+(dt::QuarterlyDate, p::Year) = dt + Quarter(p)
    Base.:-(dt::QuarterlyDate, p::Year) = dt - Quarter(p)

    # range
    function Dates.guess(a::QuarterlyDate, b::QuarterlyDate, c::Quarter)
    	Int64(div(value(b - a), value(c)))
    end
    function Dates.guess(a::QuarterlyDate, b::QuarterlyDate, c::Year)
    	Int64(div(value(b - a), 4 * value(c)))
    end


    # parse
    @inline function Dates.tryparsenext(d::DatePart{'q'}, str, i, len)
        return Dates.tryparsenext_base10(str, i, len, Dates.min_width(d), Dates.max_width(d))
    end

    function Dates.format(io, d::DatePart{'q'}, dt)
        print(io, string(quarter(dt)))
    end

    const QuarterlyDateFormat = DateFormat{Symbol("yyyy-Qq"), Tuple{Dates.DatePart{'y'}, Dates.Delim{String, 2}, Dates.DatePart{'q'}}}(
            (
                Dates.DatePart{'y'}(4,false), Dates.Delim{String,2}("-Q"), Dates.DatePart{'q'}(1, false)), 
                Dates.ENGLISH
            )
    Dates.default_format(::Type{QuarterlyDate}) = QuarterlyDateFormat


    function Base.parse(::Type{QuarterlyDate}, str::AbstractString, df::DateFormat=QuarterlyDateFormat)
        if Dates.DatePart{'q'} ∈ Dates._directives(typeof(df))
            invoke(parse, Tuple{Type{<:TimeType}, AbstractString, DateFormat}, QuarterlyDate, str, df)
        else
            QuarterlyDate(parse(Date, str, df))
        end
    end

    function Base.tryparse(::Type{QuarterlyDate}, str::AbstractString, df::DateFormat= QuarterlyDateFormat)
        if Dates.DatePart{'q'} ∈ Dates._directives(typeof(df))
            invoke(tryparse, Tuple{Type{<:TimeType}, AbstractString, DateFormat}, QuarterlyDate, str, df)
        else
            out = tryparse(Date, str, df)
            out === nothing ? nothing : QuarterlyDate(out)
        end
    end

    """
    QuarterlyDate(d::AbstractString, format::AbstractString; locale="english") -> QuarterlyDate

    Construct a `QuarterlyDate` by parsing the date string following the pattern given in the
    `format` string.

    This method creates a `DateFormat` object each time it is called. If you are parsing many date strings of the same format, consider creating a `DateFormat` object once and using that as the second argument instead.

    ### Examples
    ```julia
    julia> QuarterlyDate("1990-01", "yyy-mm")
    julia> QuarterlyDate("1990-Q1", "yyy-Qq")
    ```
    """
    function QuarterlyDate(d::AbstractString, format::AbstractString; 
        locale::Dates.Locale = Dates.ENGLISH)
        parse(QuarterlyDate, d, DateFormat(format, locale))
    end

    """
    QuarterlyDate(d::AbstractString, df::DateFormat) -> QuarterlyDate

    Parse a QuarterlyDate from a date string `d` using a `DateFormat` object `df`.
    """
    function QuarterlyDate(d::AbstractString, format::DateFormat = QuarterlyDateFormat)
        parse(QuarterlyDate, d, format)
    end

    # show
    function Base.print(io::IO, dt::QuarterlyDate)
        y = year(dt)
        q = quarter(dt)
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        print(io, "$(yy)-Q$q")
    end
    Base.show(io::IO, ::MIME"text/plain", dt::QuarterlyDate) = print(io, dt)
    Base.show(io::IO, dt::QuarterlyDate) = print(io, QuarterlyDate, "(\"", dt, "\")")
    Base.typeinfo_implicit(::Type{QuarterlyDate}) = true

    # plot
    @recipe function f(::Type{QuarterlyDate}, x::QuarterlyDate)
        (value, dt -> string(QuarterlyDate(UTQ(round(dt)))))
    end

    # executed at runtime to avoid issues with precompiling dicts
    function __init__()
        Dates.CONVERSION_SPECIFIERS['q'] = Quarter
        Dates.CONVERSION_DEFAULTS[Quarter] = Int64(1)
        Dates.CONVERSION_TRANSLATIONS[QuarterlyDate] = (Year, Quarter)
    end

    export QuarterlyDate, quarter

    ##############################################################################
    ##
    ## YearlyDate (more for consistency than anything else)
    ##
    ##############################################################################
    """
    YearlyDate

    `YearlyDate` wraps a UTInstant{Year} and interprets it according to the proleptic
    Gregorian calendar.
    """
    struct YearlyDate <: TimeType
        instant::UTInstant{Year}
        YearlyDate(v::UTInstant{Year}) = new(v)
    end
    UTY(x) = UTInstant(Year(x))
    """
    `YearlyDate(y) -> YearlyDate`
    
    Construct a `YearlyDate` type. Argument must be convertible to `Int64`
    """
    function YearlyDate(y::Int)
        YearlyDate(UTY(y))
    end
    YearlyDate(y::Year) = YearlyDate(value(y))
    YearlyDate(y) = YearlyDate(Int64(y))

    """
    `YearlyDate(dt::TimeType) -> YearlyDate`
    
    Convert a `TimeType` to a `YearlyDate`
    """
    YearlyDate(dt::TimeType) = convert(YearlyDate, dt)
    Base.convert(::Type{YearlyDate}, dt::QuarterlyDate) = YearlyDate(UTY(((value(dt) - 1) ÷ 4 + 1)))
    Base.convert(::Type{YearlyDate}, dt::MonthlyDate) = YearlyDate(UTY(((value(dt) - 1) ÷ 12 + 1)))
    Base.convert(::Type{YearlyDate}, dt::Date) = YearlyDate(year(dt))
    Base.convert(::Type{YearlyDate}, dt::DateTime) = YearlyDate(year(dt))
    Base.convert(::Type{YearlyDate}, x::Year) = YearlyDate(UTInstant(x))

    # should not be yearmonth since month of YearlyDate not defined
    Base.convert(::Type{QuarterlyDate}, dt::YearlyDate) = QuarterlyDate(UTQ(((value(dt) - 1) * 4 + 1)))
    Base.convert(::Type{MonthlyDate}, dt::YearlyDate) = MonthlyDate(UTM(((value(dt) - 1) * 12 + 1)))
    Base.convert(::Type{Date}, dt::YearlyDate) = Date(year(dt), 1)
    Base.convert(::Type{DateTime}, dt::YearlyDate) = DateTime(year(dt), 1)
    Base.convert(::Type{Year}, dt::YearlyDate) =  Year(value(dt))

    Base.promote_rule(::Type{YearlyDate}, x::Type{QuarterlyDate}) = QuarterlyDate
    Base.promote_rule(::Type{YearlyDate}, x::Type{MonthlyDate}) = MonthlyDate
    Base.promote_rule(::Type{YearlyDate}, x::Type{Date}) = Date
    Base.promote_rule(::Type{YearlyDate}, x::Type{DateTime}) = DateTime   

    Dates.eps(::Type{YearlyDate}) = Year(1)
    Dates.zero(::Type{YearlyDate}) = Year(0)

    #accessors (only bigger periods)
    Dates.year(dt::YearlyDate) = value(dt)
    # important since quarter may not reflect quarter of year actually

    Dates.Year(dt::YearlyDate) = Year(year(dt))
    Base.trunc(dt::YearlyDate, ::Type{Year}) = dt

    # arithmetics
    Base.:+(dt::YearlyDate, y::Year) = YearlyDate(UTY(value(dt) + value(y)))
    Base.:-(dt::YearlyDate, y::Year) = YearlyDate(UTY(value(dt) - value(y)))

    # range
    function Dates.guess(a::YearlyDate, b::YearlyDate, c::Year)
        Int64(div(value(b - a), value(c)))
    end


    # parse
    const YearlyDateFormat = dateformat"yyyy"
    Dates.default_format(::Type{YearlyDate}) = YearlyDateFormat

    function Base.parse(::Type{YearlyDate}, s::AbstractString, df::DateFormat = YearlyDateFormat)
        YearlyDate(parse(Date, s, df))
    end

    function Base.tryparse(::Type{YearlyDate}, s::AbstractString, df::DateFormat = YearlyDateFormat)
        out = tryparse(Date, s, df)
        out === nothing ? nothing : YearlyDate(out)
    end

    """
    YearlyDate(d::AbstractString, format::AbstractString; locale="english") -> YearlyDate

    Construct a `YearlyDate` by parsing the date string following the pattern given in the
    `format` string.

    This method creates a `DateFormat` object each time it is called. If you are parsing many date strings of the same format, consider creating a `DateFormat` object once and using that as the second argument instead.

    ### Examples
    ```julia
    julia> YearlyDate("1990", "yyyy")
    ```
    """
    function YearlyDate(d::AbstractString, format::AbstractString; 
        locale::Dates.Locale = Dates.ENGLISH)
        parse(YearlyDate, d, DateFormat(format, locale))
    end

    """
    YearlyDate(d::AbstractString, df::DateFormat) -> YearlyDate

    Parse a date from a date string `d` using a `DateFormat` object `df`.
    """
    function YearlyDate(d::AbstractString, format::DateFormat = YearlyDateFormat)
        parse(YearlyDate, d, format)
    end

    # show
    function Base.print(io::IO, dt::YearlyDate)
        y = year(dt)
        yy = y < 0 ? @sprintf("%05i", y) : lpad(y, 4, "0")
        print(io, "$(yy)")
    end
    Base.show(io::IO, ::MIME"text/plain", dt::YearlyDate) = print(io, dt)
    Base.show(io::IO, dt::YearlyDate) = print(io, dt)
    Base.typeinfo_implicit(::Type{YearlyDate}) = true

    # plot
    @recipe function f(::Type{YearlyDate}, x::YearlyDate)
        (value, dt -> string(YearlyDate(UTY(round(dt)))))
    end


    export YearlyDate
end