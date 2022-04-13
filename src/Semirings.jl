# SPDX-License-Identifier: MIT

module Semirings

import LogExpFunctions: logaddexp

#======================================================================
Module's public API
======================================================================#

# Semirings
export Semiring
export BoolSemiring
export LogSemiring
export ProbabilitySemiring
export TropicalSemiring
export UnionConcatSemiring

# Semiring properties
export SemiringProperty
export IsDivisible, Divisible, NotDivisible
export IsIdempotent, Idempotent, NotIdempotent
export IsOrdered, Ordered, Unordered

#======================================================================
Abstract semiring
======================================================================#

"""
    Semiring{T} <: Number

Supertype for semirings. A semiring ``S = (R, ⊕, ⊗, 0̄, 1̄)`` with
a set ``R``, an "addition" operation ``⊕`` and a "multiplication"
operation ``⊗``.
"""
abstract type Semiring{T} <: Number end

Base.conj(x::Semiring) = conj(x.val)
Base.promote_rule(x::Type{Semiring}, y::Type{Number}) = Semiring
Base.:(==)(x::Semiring, y::Semiring) = x.val == y.val
Base.:(≈)(x::Semiring, y::Semiring) = x.val ≈ y.val
Base.show(io::IO, x::Semiring) = print(io, x.val)

#======================================================================
Semiring properties
======================================================================#

include("properties.jl")

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

IsOrdered(::Type{<:LogSemiring}) = Ordered()
IsDivisible(::Type{<:LogSemiring}) = Divisible()

Base.:+(x::LogSemiring, y::LogSemiring) = LogSemiring(logaddexp(x.val, y.val))
Base.:*(x::LogSemiring, y::LogSemiring) = LogSemiring(x.val + y.val)
Base.:/(x::LogSemiring, y::LogSemiring) = LogSemiring(x.val - y.val)
Base.zero(::Type{LogSemiring}) = LogSemiring(float(Real)(-Inf))
Base.one(::Type{LogSemiring}) = LogSemiring(zero(float(Real)))
Base.zero(::Type{LogSemiring{T}}) where T = LogSemiring(float(T)(-Inf))
Base.one(::Type{LogSemiring{T}}) where T = LogSemiring(zero(T))
Base.:<(x::LogSemiring, y::LogSemiring) = x.val < y.val
Base.typemin(x::Type{LogSemiring{T}}) where T = LogSemiring{T}(typemin(T))
Base.typemax(x::Type{LogSemiring{T}}) where T = LogSemiring{T}(typemax(T))

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

Base.:+(x::TropicalSemiring, y::TropicalSemiring) =
    TropicalSemiring(max(x.val, y.val))
Base.:*(x::TropicalSemiring, y::TropicalSemiring) =
    TropicalSemiring(x.val + y.val)
Base.zero(::Type{TropicalSemiring{T}}) where T = TropicalSemiring{T}(T(-Inf))
Base.one(::Type{TropicalSemiring{T}}) where T = TropicalSemiring{T}(T(0))
Base.isless(x::TropicalSemiring, y::TropicalSemiring) = isless(x.val, y.val)
Base.typemin(x::Type{TropicalSemiring{T}}) where T =
    TropicalSemiring{T}(typemin(T))
Base.typemax(x::Type{TropicalSemiring{T}}) where T =
    TropicalSemiring{T}(typemax(T))
Base.conj(x::TropicalSemiring{T}) where T = TropicalSemiring{T}(conj(x.val))

#======================================================================
alternation-concatenation-semiring
======================================================================#

#const SymbolSequence{N} = NTuple{N, Any} where N
#SymbolSequence(syms) = SymbolSequence{length(syms)}(syms)
#
#"""
#    struct ACSemiring <: Semiring
#        val::Set{<:SymbolSequence}
#    end
#
#Union-Concatenation semiring.
#"""
#struct UnionConcatSemiring <: Semiring
#    val::Set{<:SymbolSequence}
#end
#
#Base.:+(x::UnionConcatSemiring, y::UnionConcatSemiring) =
#    UnionConcatSemiring(union(x.val, y.val))
#function Base.:*(x::ACSemiring, y::ACSemiring)
#    newseqs = Set{SymbolSequence}()
#    for xᵢ in x.val
#        for yᵢ in y.val
#            push!(newseqs, SymbolSequence(vcat(xᵢ..., yᵢ...)))
#        end
#    end
#    ACSemiring(newseqs)
#end
#
#Base.zero(::ACSemiring) = ACSemiring(Set{SymbolSequence}())
#Base.one(::ACSemiring) = ACSemiring(Set([tuple()]))
#Base.conj(x::ACSemiring) = identity
#
#
##======================================================================
#prob-semiring
#======================================================================#
#
#"""
#    struct ProbabilitySemiring{T<:AbstractFloat} <: Semiring
#        val::T
#    end
#
#Probability semiring defined as :
#  * ``x \\oplus y \\triangleq x + y``
#  * ``x \\otimes y \\triangleq x \\cdot y``
#  * ``x \\oslash y \\triangleq \\frac{x}{y}``
#``\\forall x, y \\in [0, 1]``.
#"""
#struct ProbabilitySemiring{T<:AbstractFloat} <: Semiring
#    val::T
#end
#
#SemiringOrderedProperty(::Type{<:LogSemiring}) = IsOrdered()
#SemiringDivisibleProperty(::Type{<:LogSemiring}) = IsDivisible()
#
#Base.:+(x::ProbabilitySemiring, y::ProbabilitySemiring) =
#    ProbabilitySemiring(x.val + y.val)
#Base.:*(x::ProbabilitySemiring, y::ProbabilitySemiring) =
#    ProbabilitySemiring(x.val * y.val)
#Base.:/(x::ProbabilitySemiring, y::ProbabilitySemiring) =
#    ProbabilitySemifield(x.val / y.val)
#Base.zero(::Type{ProbabilitySemifield{T}}) where T = ProbabilitySemiring(T(0))
#Base.one(::Type{ProbabilitySemifield{T}}) where T = ProbabilitySemiring(T(1))
#Base.isless(x::ProbabilitySemiring, y::ProbabilitySemiring) = isless(x.val, y.val)
#Base.typemin(x::Type{ProbabilitySemifield{T}}) where T = zero(T)
#Base.typemax(x::Type{ProbabilitySemifield{T}}) where T = one(T)

end

