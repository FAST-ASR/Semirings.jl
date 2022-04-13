# SPDX-License-Identifier: MIT

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
