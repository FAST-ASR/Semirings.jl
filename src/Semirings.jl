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
    Semiring

Supertype for semirings. A semiring ``S = (R, ⊕, ⊗, 0̄, 1̄)`` with
a set ``R``, an "addition" operation ``⊕`` and a "multiplication"
operation ``⊗``.
"""
abstract type Semiring <: Number end

Base.zero(x::T) where T<:Semiring = zero(T)
Base.one(x::T) where T<:Semiring = one(T)
Base.conj(x::Semiring) = conj(x.val)
Base.promote_rule(x::Type{Semiring}, y::Type{Number}) = Semiring
Base.show(io::IO, x::Semiring) = print(io, x.val)

#======================================================================
Semiring properties
======================================================================#

"""
    SemiringProperty

Supertype for semiring properties.
"""
abstract type SemiringProperty end

"""
    IsDivisible <: SemiringProperty

Divisible property of a semiring. A semiring is *divisible* if all its
elements ``x`` but ``0`` has an inverse ``z`` such that ``x * z = 1``.
"""
abstract type IsDivisible <: SemiringProperty end

struct Divisible<: IsDivisible end
struct NotDivisible <: IsDivisible end
IsDivisible(::Type) = NotDivisible()

"""
    IsIdempotent <: SemiringProperty

Idempotent property of a semiring. A semiring is *idempotent* if
``x + x = x`` for all ``x``.
"""
abstract type IsIdempotent <: SemiringProperty end

struct Idempotent <: IsIdempotent end
struct NotIdempotent <: IsIdempotent end
IsIdempotent(::Type) = NotIdempotent()

"""
    IsOrdered <: SemiringProperty

Ordered property of a semiring. A semiring is *ordered* if:
  1. ``a + c ≤ b + c``, ``∀ a,b,c ∈ R`` and ``a ≤ b``
  2. ``ac ≤ bc`` and ``ca ≤ cb``, ``∀ a, b, c ∈ R``, ``0 ≤ c`` and ``a ≤ b``
"""
abstract type IsOrdered <: SemiringProperty end

struct Ordered <: IsOrdered end
struct Unordered <: IsOrdered end
IsOrdered(::Type) = Unordered()

#======================================================================
Boolean semiring
======================================================================#

"""
    struct Boolsemiring <: Semiring
        val::Bool
    end

Boolean semiring: ``R = ({true, false}, ∨, ∧, false, true)``.
"""
struct BoolSemiring <: Semiring
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
    struct LogSemiring{T<:Real} <: Semiring
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

IsOrdered(::Type{<:LogSemiring}) = Ordered()
IsDivisible(::Type{<:LogSemiring}) = Divisible()

Base.:+(x::LogSemiring, y::LogSemiring) = LogSemiring(logaddexp(x.val, y.val))
Base.:*(x::LogSemiring, y::LogSemiring) = LogSemiring(x.val + y.val)
Base.:/(x::LogSemiring, y::LogSemiring) = LogSemiring(x.val - y.val)
Base.zero(::Type{LogSemiring{T}}) where T = LogSemiring(float(T)(-Inf))
Base.one(::Type{LogSemiring{T}}) where T = LogSemiring(zero(T))
Base.:<(x::LogSemiring, y::LogSemiring) = x.val < y.val
Base.:(==)(x::LogSemiring, y::LogSemiring) = x.val == y.val
Base.typemin(x::Type{LogSemiring{T}}) where T = LogSemiring{T}(typemin(T))
Base.typemax(x::Type{LogSemiring{T}}) where T = LogSemiring{T}(typemax(T))

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

