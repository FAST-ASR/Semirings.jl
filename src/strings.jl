# SPDX-License-Identifier: MIT

"""
    longestcommonprefix(x::AbstractString, y::AbstractString)

Return the longest common prefix between `x` and `y`.
"""
function longestcommonprefix(x::AbstractString, y::AbstractString)
    lastidx = 0
    for i in 1:min(length(x), length(y))
        if x[i] != y[i]
            break
        end
        lastidx = i
    end
    x[1:lastidx]
end

"""
    struct StringZero <: AbstractString end

The zero element of the string semiring.
"""
struct StringZero <: AbstractString end
const ∞ = StringZero()

Base.ncodeunits(::StringZero) = 3
Base.codeunit(::StringZero) = UInt8
Base.isvalid(::StringZero, i::Integer) = i == 1 ? true : false
Base.iterate(::StringZero) = ("∞", 1)
Base.iterate(::StringZero, ::Integer) = nothing
Base.show(io::IO, x::StringZero) = print(io, "∞")
Base.:*(x::StringZero, y::AbstractString) = x
Base.:*(x::AbstractString, y::StringZero) = y
longestcommonprefix(x::StringZero, y::AbstractString) = y
longestcommonprefix(x::AbstractString, y::StringZero) = x
