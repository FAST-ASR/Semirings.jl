# SPDX-License-Identifier: MIT

function _notdefinedfor(prop)
    # Get the before the last function name in the stacktrace.
    fn = stacktrace(backtrace())[2].func
    throw(DomainError(fn, "$fn is not defined for $prop semirings"))
end

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

struct Divisible <: IsDivisible end
struct NotDivisible <: IsDivisible end
Base.promote_rule(::Type{Divisible}, ::Type{NotDivisible}) = NotDivisible
IsDivisible(::Type) = NotDivisible

Base.:/(x::Semiring, y::Semiring) where T <: Semiring =
    Base.:/(IsDivisible(typeof(y)), x, y)
Base.:/(::Type{NotDivisible}, x::Semiring, y::Semiring) =
    _notdefinedfor(NotDivisible)

"""
    IsIdempotent <: SemiringProperty

Idempotent property of a semiring. A semiring is *idempotent* if
``x + x = x`` for all ``x``.
"""
abstract type IsIdempotent <: SemiringProperty end

struct Idempotent <: IsIdempotent end
struct NotIdempotent <: IsIdempotent end
IsIdempotent(::Type) = NotIdempotent

"""
    IsOrdered <: SemiringProperty

Ordered property of a semiring. A semiring is *ordered* if:
  1. ``a + c ≤ b + c``, ``∀ a,b,c ∈ R`` and ``a ≤ b``
  2. ``ac ≤ bc`` and ``ca ≤ cb``, ``∀ a, b, c ∈ R``, ``0 ≤ c`` and ``a ≤ b``
"""
abstract type IsOrdered <: SemiringProperty end

struct Ordered <: IsOrdered end
struct Unordered <: IsOrdered end
Base.convert(::Type{Unordered}, ::Ordered) = Unordered
Base.convert(::Type{Ordered}, ::Unordered) = Unordered
Base.promote_rule(::Type{Ordered}, ::Type{Unordered}) = Unordered
IsOrdered(::Type) = Unordered

Base.typemin(T::Type{<:Semiring}) = Base.typemin(IsOrdered(T), T)
Base.typemin(x::Semiring) = Base.typemin(IsOrdered(typeof(x)), typeof(x))
Base.typemin(::Type{Unordered}, ::Type{<:Semiring}) = _notdefinedfor(Unordered)

Base.typemax(T::Type{<:Semiring}) = Base.typemax(IsOrdered(T), T)
Base.typemax(x::Semiring) = Base.typemax(IsOrdered(typeof(x)), typeof(x))
Base.typemax(::Type{Unordered}, ::Type{<:Semiring}) = _notdefinedfor(Unordered)

Base.isless(x::Tx, y::Ty) where {Tx<:Semiring, Ty<:Semiring} =
    Base.isless(promote_type(IsOrdered(Tx), IsOrdered(Ty)), x, y)
Base.isless(::Type{Unordered}, x::Semiring, y::Semiring) = _notdefinedfor(Unordered)
Base.isless(::Type{Ordered}, x::Semiring, y::Semiring) = val(x) < val(y)

