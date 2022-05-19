# SPDX-License-Identifier: MIT

#======================================================================
Boolean semiring
======================================================================#

"""
    struct BoolSemiring <: Semiring{Bool}
        val::Bool
    end

Boolean semiring: ``R = ({true, false}, ∨, ∧, false, true)``.
"""
struct BoolSemiring <: Semiring
    val::Bool
end

IsIdempotent(::Type{<:BoolSemiring}) = Idempotent

Base.:+(x::BoolSemiring, y::BoolSemiring) = BoolSemiring(x.val || y.val)
Base.:*(x::BoolSemiring, y::BoolSemiring) = BoolSemiring(x.val && y.val)
Base.zero(::BoolSemiring) = BoolSemiring(false)
Base.one(::BoolSemiring) = BoolSemiring(true)

#======================================================================
Logarithmic semiring
======================================================================#

"""
    struct LogSemiring{T<:Real} <: Semiring{T}
        val::T
    end

Logarithmic semiring: ``R = (ℝ, ln(eˣ + eʸ), +, -∞, 0)``.
"""
struct LogSemiring{T<:Real} <: Semiring
    val::T
end


Base.promote_rule(::Type{LogSemiring{Tx}}, ::Type{LogSemiring{Ty}}) where {Tx,Ty} =
    LogSemiring{promote_type(Tx, Ty)}
Base.float(::Type{LogSemiring{T}}) where T = LogSemiring{float(T)}
Base.float(x::LogSemiring{T}) where T = LogSemiring(float(x.val))

IsDivisible(::Type{<:LogSemiring}) = Divisible
IsOrdered(::Type{<:LogSemiring}) = Ordered

Base.:+(x::LogSemiring, y::LogSemiring) = LogSemiring(logaddexp(x.val, y.val))
Base.:*(x::LogSemiring, y::LogSemiring) = LogSemiring(x.val + y.val)
Base.:/(x::LogSemiring, y::LogSemiring) = LogSemiring(x.val - y.val)
Base.zero(::Type{LogSemiring}) = zero(LogSemiring{float(Real)})
Base.one(::Type{LogSemiring}) = one(LogSemiring{float(Real)})
Base.zero(::Type{LogSemiring{T}}) where T = LogSemiring(float(T)(-Inf))
Base.one(::Type{LogSemiring{T}}) where T = LogSemiring(zero(float(T)))
Base.typemin(x::Type{LogSemiring{T}}) where T =
    LogSemiring{T}(typemin(float(T)))
Base.typemax(x::Type{LogSemiring{T}}) where T =
    LogSemiring{T}(typemax(float(T)))

#======================================================================
Probability semiring
======================================================================#

"""
    struct ProbSemiring{T<:Real} <: Semiring{T}
        val::T
    end

Probability semiring: ``R = (ℝ, +, ⋅, 0, +∞)``.
"""
struct ProbSemiring{T<:Real} <: Semiring
    val::T
end

Base.promote_rule(::Type{ProbSemiring{Tx}}, ::Type{ProbSemiring{Ty}}) where {Tx,Ty} =
    ProbSemiring{promote_type(Tx, Ty)}
Base.float(::Type{ProbSemiring{T}}) where T = ProbSemiring{float(T)}
Base.float(x::ProbSemiring{T}) where T = ProbSemiring(float(x.val))

IsDivisible(::Type{<:ProbSemiring}) = Divisible
IsOrdered(::Type{<:ProbSemiring}) = Ordered

Base.:+(x::ProbSemiring, y::ProbSemiring) = ProbSemiring(x.val + y.val)
Base.:*(x::ProbSemiring, y::ProbSemiring) = ProbSemiring(x.val * y.val)
Base.:/(x::ProbSemiring, y::ProbSemiring) = ProbSemiring(x.val / y.val)
Base.zero(::Type{ProbSemiring}) = zero(ProbSemiring{Real})
Base.one(::Type{ProbSemiring}) = one(ProbSemiring{Real})
Base.zero(::Type{ProbSemiring{T}}) where T = ProbSemiring(zero(float(T)))
Base.one(::Type{ProbSemiring{T}}) where T = ProbSemiring(one(float(T)))
Base.typemin(x::Type{ProbSemiring{T}}) where T = zero(ProbSemiring{T})
Base.typemax(x::Type{ProbSemiring{T}}) where T =
    ProbSemiring{T}(typemax(float(T)))

"""
    struct ProductSemiring{T1<:Semiring, T2<:Semiring} <: Semiring{T}
        val1::T1
        val2::T2
    end

Produc semiring ``R = R_1 \times R_2`` where ``\times`` is the
Cartesian product.
"""
struct ProductSemiring{T1<:Semiring,T2<:Semiring} <: Semiring
    val1::T1
    val2::T2
end

val(x::ProductSemiring) = (val(x.val1), val(x.val2))

Base.promote_rule(::Type{ProductSemiring{T1x, T2x}},
                  ::Type{ProductSemiring{T1y,T2y}}) where {T1x,T2x,T1y,T2y} =
    ProductSemiring{promote_type(T1x, T1y),promote_type(T2x,T2y)}
Base.float(::Type{ProductSemiring{T1,T2}}) where {T1,T2} =
    ProductSemiring{float(T1),float(T2)}
Base.float(x::ProductSemiring) = ProductSemiring(float(x.val1), float(y.val2))

IsDivisible(::Type{ProductSemiring{T1,T2}}) where {T1,T2} =
    promote_type(IsDivisible(T1), IsDivisible(T2))
IsOrdered(::Type{ProductSemiring{T1,T2}}) where {T1,T2} =
    promote_type(IsOrdered(T1), IsOrdered(T2))

Base.:+(x::ProductSemiring, y::ProductSemiring) =
    ProductSemiring(x.val1 + y.val1, x.val2 + y.val2)
Base.:*(x::ProductSemiring, y::ProductSemiring) =
    ProductSemiring(x.val1 * y.val1, x.val2 * y.val2)
Base.:/(x::ProductSemiring, y::ProductSemiring) =
    ProductSemiring(x.val1 / y.val1, x.val2 / y.val2)
Base.zero(::Type{ProductSemiring{T1,T2}}) where {T1,T2} =
    ProductSemiring(zero(T1), zero(T2))
Base.one(::Type{ProductSemiring{T1,T2}}) where {T1,T2} =
    ProductSemiring(one(T1), one(T2))
Base.:<(::Type{Ordered}, x::ProductSemiring, y::ProductSemiring) =
    ! isequal(x.val1, y.val1) ? x.val1 < y.val1 : x.val2 < y.val2
Base.typemin(::Type{Ordered}, ::Type{ProductSemiring{T1,T2}}) where {T1,T2} =
    ProductSemiring(typemin(T1), typemin(T2))
Base.typemax(::Type{Ordered}, ::Type{ProductSemiring{T1,T2}}) where {T1,T2} =
    ProductSemiring(typemax(T1), typemax(T2))

#======================================================================
Tropical semiring
======================================================================#

"""
    struct TropicalSemiring{T<:Real} <: Semiring{T}
        val::T
    end

Tropical semiring: ``R = (ℝ, max, +, -∞, 0)``.
"""
struct TropicalSemiring{T<:Real} <: Semiring
    val::T
end

Base.promote_rule(::Type{TropicalSemiring{Tx}}, ::Type{TropicalSemiring{Ty}}) where {Tx,Ty} =
    TropicalSemiring{promote_type(Tx, Ty)}
Base.float(::Type{TropicalSemiring{T}}) where T = TropicalSemiring{float(T)}
Base.float(x::TropicalSemiring{T}) where T = TropicalSemiring(float(x.val))

IsDivisible(::Type{<:TropicalSemiring}) = Divisible
IsIdempotent(::Type{<:TropicalSemiring}) = Idempotent
IsOrdered(::Type{<:TropicalSemiring}) = Ordered

Base.:+(x::TropicalSemiring, y::TropicalSemiring) = TropicalSemiring(max(x.val, y.val))
Base.:*(x::TropicalSemiring, y::TropicalSemiring) = TropicalSemiring(x.val + y.val)
Base.:/(x::TropicalSemiring, y::TropicalSemiring) = TropicalSemiring(x.val - y.val)
Base.zero(::Type{TropicalSemiring}) = zero(TropicalSemiring{float(Real)})
Base.one(::Type{TropicalSemiring}) = one(TropicalSemiring{float(Real)})
Base.zero(::Type{TropicalSemiring{T}}) where T = TropicalSemiring(float(T)(-Inf))
Base.one(::Type{TropicalSemiring{T}}) where T = TropicalSemiring(zero(float(T)))
Base.typemin(x::Type{TropicalSemiring{T}}) where T =
    TropicalSemiring{T}(typemin(float(T)))
Base.typemax(x::Type{TropicalSemiring{T}}) where T =
    TropicalSemiring{T}(typemax(float(T)))

#======================================================================
String semiring
======================================================================#

"""
    struct StringSemiring{T<:AbstractString} <: Semiring
        val::T
    end

String semiring: ``R = (\\Sigma\\^*, \\land, \\cdot, \\infty, \\epsilon)``,
where ``x \\land y`` is the longest common prefix between ``x`` and
``y``, ``\\cdot`` is the string concatentation operation.
"""
struct StringSemiring <: Semiring
    val::AbstractString
end

IsIdempotent(::Type{<:StringSemiring}) = Idempotent

Base.zero(::Type{<:StringSemiring}) = StringSemiring(∞)
Base.one(::Type{<:StringSemiring}) = StringSemiring("")
Base.:+(x::StringSemiring, y::StringSemiring) =
    StringSemiring(longestcommonprefix(val(x), val(y)))
Base.:*(x::StringSemiring, y::StringSemiring) = StringSemiring(val(x) * val(y))
Base.conj(x::StringSemiring) = x
Base.:(==)(x::StringSemiring, y::StringSemiring) = val(x) == val(y)
Base.:(≈)(x::StringSemiring, y::StringSemiring) = x == y

#======================================================================
Union-Concatenation semiring
======================================================================#

"""
    struct UnionConcatSemiring <: Semiring
        val::Set{AbstractString}
    end

Union-Concatenation semiring: ``R = (\\Sigma\\^*, \\cup, \\cdot,
\\{\\}, \\{\\epsilon\\})`` over set of symbol sequence.
"""
struct UnionConcatSemiring <: Semiring
    val::Set{AbstractString}
end

IsIdempotent(::Type{<:UnionConcatSemiring}) = Idempotent

Base.:+(x::UnionConcatSemiring, y::UnionConcatSemiring) =
    UnionConcatSemiring(union(val(x), val(y)))

function Base.:*(x::UnionConcatSemiring, y::UnionConcatSemiring)
    newseqs = Set{AbstractString}()
    for xᵢ in val(x)
        for yᵢ in val(y)
            push!(newseqs, xᵢ * yᵢ)
        end
    end
    UnionConcatSemiring(newseqs)
end

Base.zero(::Type{UnionConcatSemiring}) = UnionConcatSemiring(Set{AbstractString}())
Base.one(::Type{UnionConcatSemiring}) = UnionConcatSemiring(Set{AbstractString}([""]))
Base.conj(x::UnionConcatSemiring) = x
Base.:(==)(x::UnionConcatSemiring, y::UnionConcatSemiring) = issetequal(x.val, y.val)
Base.:(≈)(x::UnionConcatSemiring, y::UnionConcatSemiring) = x == y

#======================================================================
global functions
======================================================================#

for K in [:BoolSemiring, :StringSemiring, :UnionConcatSemiring]
    eval(:( $K(x::Semiring) = $K(val(x)) ))
end

for K in [:StringSemiring, :UnionConcatSemiring]
    eval(:( $K(x::Bool) = x ? one($K) : zero($K) ))
end

for K in [:LogSemiring, :ProbSemiring, :TropicalSemiring]
    eval(:( $K{T}(x::Semiring) where T <: Real = $K{T}(x.val) ))
    eval(:( $K{T}(x::Bool) where T <: Real = x ? one($K{T}) : zero($K{T}) ))
end
