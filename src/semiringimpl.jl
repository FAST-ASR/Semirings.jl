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
struct BoolSemiring <: Semiring{Bool}
    val::Bool
end

IsIdempotent(::Type{<:BoolSemiring}) = Idempotent()

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
struct LogSemiring{T<:Real} <: Semiring{T}
    val::T
end

Base.promote_rule(::Type{LogSemiring{Tx}}, ::Type{LogSemiring{Ty}}) where {Tx,Ty} =
    LogSemiring{promote_type(Tx, Ty)}
Base.float(::Type{LogSemiring{T}}) where T = LogSemiring{float(T)}
Base.float(x::LogSemiring{T}) where T = LogSemiring(float(x.val))

IsDivisible(::Type{<:LogSemiring}) = Divisible()
IsOrdered(::Type{<:LogSemiring}) = Ordered()

Base.:+(x::LogSemiring, y::LogSemiring) = LogSemiring(logaddexp(x.val, y.val))
Base.:*(x::LogSemiring, y::LogSemiring) = LogSemiring(x.val + y.val)
Base.:/(x::LogSemiring, y::LogSemiring) = LogSemiring(x.val - y.val)
Base.zero(::Type{LogSemiring}) = zero(LogSemiring{float(Real)})
Base.one(::Type{LogSemiring}) = one(LogSemiring{float(Real)})
Base.zero(::Type{LogSemiring{T}}) where T = LogSemiring(float(T)(-Inf))
Base.one(::Type{LogSemiring{T}}) where T = LogSemiring(zero(float(T)))
Base.:<(x::LogSemiring, y::LogSemiring) = x.val < y.val
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
struct ProbSemiring{T<:Real} <: Semiring{T}
    val::T
end

Base.promote_rule(::Type{ProbSemiring{Tx}}, ::Type{ProbSemiring{Ty}}) where {Tx,Ty} =
    ProbSemiring{promote_type(Tx, Ty)}
Base.float(::Type{ProbSemiring{T}}) where T = ProbSemiring{float(T)}
Base.float(x::ProbSemiring{T}) where T = ProbSemiring(float(x.val))

IsDivisible(::Type{<:ProbSemiring}) = Divisible()
IsOrdered(::Type{<:ProbSemiring}) = Ordered()

Base.:+(x::ProbSemiring, y::ProbSemiring) = ProbSemiring(x.val + y.val)
Base.:*(x::ProbSemiring, y::ProbSemiring) = ProbSemiring(x.val * y.val)
Base.:/(x::ProbSemiring, y::ProbSemiring) = ProbSemiring(x.val / y.val)
Base.zero(::Type{ProbSemiring}) = zero(ProbSemiring{Real})
Base.one(::Type{ProbSemiring}) = one(ProbSemiring{Real})
Base.zero(::Type{ProbSemiring{T}}) where T = ProbSemiring(zero(float(T)))
Base.one(::Type{ProbSemiring{T}}) where T = ProbSemiring(one(float(T)))
Base.:<(x::ProbSemiring, y::ProbSemiring) = x.val < y.val
Base.typemin(x::Type{ProbSemiring{T}}) where T = zero(ProbSemiring{T})
Base.typemax(x::Type{ProbSemiring{T}}) where T =
    ProbSemiring{T}(typemax(float(T)))

#======================================================================
Tropical semiring
======================================================================#

"""
    struct TropicalSemiring{T<:Real} <: Semiring{T}
        val::T
    end

Tropical semiring: ``R = (ℝ, max, +, -∞, 0)``.
"""
struct TropicalSemiring{T<:Real} <: Semiring{T}
    val::T
end

Base.promote_rule(::Type{TropicalSemiring{Tx}}, ::Type{TropicalSemiring{Ty}}) where {Tx,Ty} =
    TropicalSemiring{promote_type(Tx, Ty)}
Base.float(::Type{TropicalSemiring{T}}) where T = TropicalSemiring{float(T)}
Base.float(x::TropicalSemiring{T}) where T = TropicalSemiring(float(x.val))

IsDivisible(::Type{<:TropicalSemiring}) = Divisible()
IsIdempotent(::Type{<:TropicalSemiring}) = Idempotent()
IsOrdered(::Type{<:TropicalSemiring}) = Ordered()

Base.:+(x::TropicalSemiring, y::TropicalSemiring) = TropicalSemiring(max(x.val, y.val))
Base.:*(x::TropicalSemiring, y::TropicalSemiring) = TropicalSemiring(x.val + y.val)
Base.:/(x::TropicalSemiring, y::TropicalSemiring) = TropicalSemiring(x.val - y.val)
Base.zero(::Type{TropicalSemiring}) = zero(TropicalSemiring{float(Real)})
Base.one(::Type{TropicalSemiring}) = one(TropicalSemiring{float(Real)})
Base.zero(::Type{TropicalSemiring{T}}) where T = TropicalSemiring(float(T)(-Inf))
Base.one(::Type{TropicalSemiring{T}}) where T = TropicalSemiring(zero(float(T)))
Base.:<(x::TropicalSemiring, y::TropicalSemiring) = x.val < y.val
Base.typemin(x::Type{TropicalSemiring{T}}) where T =
    TropicalSemiring{T}(typemin(float(T)))
Base.typemax(x::Type{TropicalSemiring{T}}) where T =
    TropicalSemiring{T}(typemax(float(T)))

#======================================================================
Union-Concatenation semiring
======================================================================#

const SymbolSequence{N} = NTuple{N, Any} where N
SymbolSequence(syms) = SymbolSequence{length(syms)}(syms)
SymbolSequence() = SymbolSequence{0}()

"""
    struct UnionConcatSemiring <: Semiring
        val::Set{<:SymbolSequence}
    end

Union-Concatenation semiring: ``R = (ℝ, ∪, concat, {}, {""})`` over
set of symbol sequence.

See also: [`SymbolSequence`](@ref).
"""
struct UnionConcatSemiring <: Semiring{Set{SymbolSequence}}
    val::Set{SymbolSequence}
end
UnionConcatSemiring(x::SymbolSequence) = UnionConcatSemiring(Set([x]))

IsIdempotent(::Type{<:UnionConcatSemiring}) = Idempotent()

Base.:+(x::UnionConcatSemiring, y::UnionConcatSemiring) =
    UnionConcatSemiring(union(x.val, y.val))

function Base.:*(x::UnionConcatSemiring, y::UnionConcatSemiring)
    newseqs = Set{SymbolSequence}()
    for xᵢ in x.val
        for yᵢ in y.val
            push!(newseqs, SymbolSequence(vcat(xᵢ..., yᵢ...)))
        end
    end
    UnionConcatSemiring(newseqs)
end

Base.zero(::Type{UnionConcatSemiring}) = UnionConcatSemiring(Set{SymbolSequence}())
Base.one(::Type{UnionConcatSemiring}) = UnionConcatSemiring(Set([tuple()]))
Base.conj(x::UnionConcatSemiring) = identity
Base.:(==)(x::UnionConcatSemiring, y::UnionConcatSemiring) = issetequal(x.val, y.val)
Base.:(≈)(x::UnionConcatSemiring, y::UnionConcatSemiring) = x == y

