module SemifieldAlgebra

export Semifield

"""
    struct Semifield{T,A,M,MI,Z,O} <: Number
        val::T
    end

`T` is the value type, `A` is the addition function, `M` is the
multiplication function, `MI` is the muliplication inverse function,
`Z` is the zero element function and `O` is the one element function.
"""
struct Semifield{T,A,M,MI,Z,O} <: Number
    val::T
end

Base.show(io::IO, x::Semifield) = print(io, x.val)
Base.:+(x::Semifield{T,A,M,MI,Z,O}, y::Semifield{T,A,M,MI,Z,O}) where {T,A,M,MI,Z,O} =
    Semifield{T,A,M,MI,Z,O}( A(x.val, y.val) )
Base.:*(x::Semifield{T,A,M,MI,Z,O}, y::Semifield{T,A,M,MI,Z,O}) where {T,A,M,MI,Z,O} =
    Semifield{T,A,M,MI,Z,O}( M(x.val, y.val) )
Base.:/(x::Semifield{T,A,M,MI,Z,O}, y::Semifield{T,A,M,MI,Z,O}) where {T,A,M,MI,Z,O} =
    Semifield{T,A,M,MI,Z,O}( MI(x.val, y.val) )
Base.zero(::Type{Semifield{T,A,M,MI,Z,O}}) where {T,A,M,MI,Z,O} = Semifield{T,A,M,MI,Z,O}(Z)
Base.zero(::Semifield{T,A,M,MI,Z,O}) where {T,A,M,MI,Z,O} = Semifield{T,A,M,MI,Z,O}(Z)
Base.one(::Type{Semifield{T,A,M,MI,Z,O}})  where {T,A,M,MI,Z,O} = Semifield{T,A,M,MI,Z,O}(O)
Base.one(::Semifield{T,A,M,MI,Z,O}) where {T,A,M,MI,Z,O} = Semifield{T,A,M,MI,Z,O}(O)

end

