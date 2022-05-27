# SPDX-License-Identifier: MIT

#======================================================================
String monoid
======================================================================#

"""
    struct StringMonoid <: Monoid
        val::AbstractString
    end

String monoid: ``R = (\\Sigma\\^*, concat, \\epsilon)``.
"""
struct StringMonoid <: Monoid
    val::AbstractString
end

Base.:*(x::StringMonoid, y::StringMonoid) = StringMonoid(x.val * y.val)
Base.one(::Type{StringMonoid}) = StringMonoid("")
Base.:(≈)(x::StringMonoid, y::StringMonoid) = val(x) == val(y)

#======================================================================
Sequence monoid
======================================================================#

"""
    struct SequenceMonoid <: Monoid
        val::
    end

String monoid: ``R = (\\Sigma\\^*, concat, \\epsilon)``.
"""
struct SequenceMonoid <: Monoid
    val::NTuple
end

Base.:*(x::SequenceMonoid, y::SequenceMonoid) =
    SequenceMonoid(tuple(val(x)..., val(y)...))
Base.one(::Type{SequenceMonoid}) = SequenceMonoid(tuple())
Base.:(≈)(x::SequenceMonoid, y::SequenceMonoid) = val(x) == val(y)

