
"""
`Quarter(v) -> Quarter`

Construct a `Quarter` object with the given `v` value. Input must be losslessly convertible to an Int64.
"""
struct Quarter <: DatePeriod
	value::Int64
    Quarter(v::Number) = new(v)
end

#arithmetic
Base.:+(x::Date, y::Quarter) = x + Month(y)
Base.:-(x::Date, y::Quarter) = x - Month(y)
Base.:+(x::DateTime, y::Quarter) = x + Month(y)
Base.:-(x::DateTime, y::Quarter) = x - Month(y)
#periods
let vmax = typemax(Int64) ÷ 4, vmin = typemin(Int64) ÷ 4
    @eval function Base.convert(::Type{Quarter}, x::Year)
        $vmin ≤ value(x) ≤ $vmax || throw(InexactError(:convert, Quarter, x))
        Quarter(value(x) * 4)
    end
end
Base.convert(::Type{Year}, x::Quarter) = Year(divexact(value(x), 4))
Base.promote_rule(::Type{Year}, ::Type{Quarter}) = Quarter

let vmax = typemax(Int64) ÷ 3, vmin = typemin(Int64) ÷ 3
    @eval function Base.convert(::Type{Month}, x::Quarter)
        $vmin ≤ value(x) ≤ $vmax || throw(InexactError(:convert, Month, x))
        Month(value(x) * 3)
    end
end
Base.convert(::Type{Quarter}, x::Month) = Quarter(Dates.divexact(value(x), 3))
Base.promote_rule(::Type{Quarter}, ::Type{Month}) = Month
Base.hash(x::Quarter, h::UInt) = hash(Month(x), h)
Dates.toms(x::Quarter) = Dates.toms(Month(x))
Dates.days(x::Quarter) = Dates.days(Month(x))
Dates.periodisless(::Year, ::Quarter) = false
Dates.periodisless(::Period, ::Quarter) = true
Dates.periodisless(::Quarter, ::Month) = false
# rounding
Base.floor(dt::Date, p::Quarter) = floor(dt, Month(p))


function Base.print(io::IO, q::Quarter)
    if value(q) == 1
        print(io, "1 quarter")
    else
        print(io, "$(value(q)) quarters")
    end
end
Base.show(io::IO, q::Quarter) = print(io, q)


"""
`Quarter(dt::TimeType) -> Quarter`

The quarter part of a `TimeType` as a `Quarter`
"""
Quarter(dt::Date) = Quarter(quarterofyear(dt))
Quarter(dt::DateTime) = Quarter(quarterofyear(dt))

export Quarter



