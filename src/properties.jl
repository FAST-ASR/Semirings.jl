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

struct Divisible<: IsDivisible end
struct NotDivisible <: IsDivisible end
IsDivisible(::Type) = NotDivisible()

Base.:/(x::Semiring, y::Semiring) where T <: Semiring =
    Base.:/(IsDivisible(typeof(y)), x, y)
Base.:/(::NotDivisible, x::Semiring, y::Semiring) =
    _notdefinedfor(NotDivisible)

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
promote_rule(::Type{Ordered}, ::Type{Unordered}) = Unordered
IsOrdered(::Type) = Unordered()
IsOrdered(Tx::Type, Ty::Type) =
    promote_type(typeof(IsOrdered(Tx)), typeof(IsOrdered(Ty)))()

Base.typemin(T::Type{<:Semiring}) = Base.typemin(IsOrdered(T), T)
Base.typemin(x::Semiring) = Base.typemin(IsOrdered(typeof(x)), typeof(x))
Base.typemin(::Unordered, ::Type{<:Semiring}) = _notdefinedfor(Unordered)
Base.typemin(::Ordered, ::Type{Semiring{T}}) where T= Base.typemin(T)

Base.typemax(T::Type{<:Semiring}) = Base.typemax(IsOrdered(T), T)
Base.typemax(x::Semiring) = Base.typemax(IsOrdered(typeof(x)), typeof(x))
Base.typemax(::Unordered, ::Type{<:Semiring}) = _notdefinedfor(Unordered)

Base.:<(x::Tx, y::Ty) where {Tx<:Semiring, Ty<:Semiring} =
    Base.:<(IsOrdered(Tx, Ty), x, y)
Base.:<(::Unordered, x::Semiring, y::Semiring) = _notdefinedfor(Unordered)
Base.:<(::Ordered, x::Semiring, y::Semiring) = x.val < y.val

