# SPDX-License-Identifier: MIT

"""
    Semiring <: Number

Supertype for semirings. A semiring ``S = (R, ⊕, ⊗, 0̄, 1̄)`` with
a set ``R``, an "addition" operation ``⊕`` and a "multiplication"
operation ``⊗``.
"""
abstract type Semiring <: Number end

Base.conj(x::Semiring) = typeof(x)(conj(x.val))
Base.promote_rule(x::Type{Semiring}, y::Type{Number}) = x
Base.:(==)(x::Semiring, y::Semiring) = x.val == y.val
Base.:(≈)(x::Semiring, y::Semiring) = x.val ≈ y.val
Base.show(io::IO, x::T) where T<:Semiring = print(io, T, "(", x.val, ")")
Base.show(io::IO, ::MIME"text/plain", x::T) where T<:Semiring = print(io, x.val)
#Base.print(io::IO, x::T) where T<:Semiring = print(io, x.val)