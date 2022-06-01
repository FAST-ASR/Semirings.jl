# SPDX-License-Identifier: MIT

"""
    Monoid <: Number

Supertype for monoids. A monoid ``M = (R, \\otimes, \\bar{1})`` is a
set ``R``, with an associative operation ``\\otimes``.
"""
abstract type Monoid <: Number end

val(x::Monoid) = x.val
Base.promote_rule(x::Type{Monoid}, y::Type{Number}) = x
Base.:(==)(x::Monoid, y::Monoid) = val(x) == val(y)
Base.:(≈)(x::Monoid, y::Monoid) = val(x) ≈ val(y)
Base.one(x::Monoid) = one(typeof(x))
Base.show(io::IO, x::Monoid) = print(io, typeof(x), "(", val(x),  ")")
Base.show(io::IO, m::MIME"text/plain", x::Monoid) = print(io, val(x))
