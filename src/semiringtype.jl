# SPDX-License-Identifier: MIT

"""
    Semiring <: Number

Supertype for semirings. A semiring ``S = (R, ⊕, ⊗, 0̄, 1̄)`` with
a set ``R``, an "addition" operation ``⊕`` and a "multiplication"
operation ``⊗``.
"""
abstract type Semiring <: Number end

val(x::Semiring) = x.val
Base.conj(x::Semiring) = typeof(x)(conj(val(x)))
Base.abs(x::Semiring) = x
Base.promote_rule(x::Type{Semiring}, y::Type{Number}) = x
Base.:(==)(x::Semiring, y::Semiring) = val(x) == val(y)
Base.:(≈)(x::Semiring, y::Semiring) = val(x) ≈ val(y)
Base.zero(x::Semiring) = zero(typeof(x))
Base.one(x::Semiring) = one(typeof(x))
Base.show(io::IO, x::Semiring) = print(io, typeof(x), "(", val(x),  ")")
Base.show(io::IO, m::MIME"text/plain", x::Semiring) = print(io, val(x))
