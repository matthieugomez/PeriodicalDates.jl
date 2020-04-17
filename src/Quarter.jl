
struct Quarter <: Period
	value::Int64
    Quarter(v::Number) = new(v)
end
(+)(dt::TimeType, q::Quarter) = dt + Month(3 * value(q))
(-)(dt::TimeType, q::Quarter) = dt - Month(3 * value(q))
function Base.convert(::Type{Month}, q::Quarter)
    Month(3 * (value(q)-1) + 1)
end
Base.convert(::Type{Quarter}, x::Month) = Month(Dates.divexact(value(x), 3))
Base.promote_rule(::Type{Quarter}, ::Type{Month}) = Month
Base.hash(x::Quarter, h::UInt) = hash(3 * value(x), h + Dates.otherperiod_seed)
Dates.toms(x::Quarter) = toms(Month(x))
Dates.tons(x::Quarter) = toms(Month(x))
Dates.days(x::Quarter) = days(Month(x))
function Base.print(io::IO, q::Quarter)
    if value(q) == 1
        print(io, "1 quarter")
    else
        print(io, "$(value(q)) quarters")
    end
end
Base.show(io::IO, q::Quarter) = print(io, q)
quarter(x) = (month(x) - 1) ÷ 3 + 1

