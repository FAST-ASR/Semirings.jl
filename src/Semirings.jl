# SPDX-License-Identifier: MIT

module Semirings

# Necessary for the logarithmic semiring
import LogExpFunctions: logaddexp

# Strings extension
export StringZero
export ∞

# Semirings
export Semiring
export BoolSemiring
export LogSemiring
export ProbSemiring
export StringSemiring
export TropicalSemiring
export UnionConcatSemiring, SymbolSequence
export val

# Semiring properties
export SemiringProperty
export IsDivisible, Divisible, NotDivisible
export IsIdempotent, Idempotent, NotIdempotent
export IsOrdered, Ordered, Unordered

include("semiringtype.jl")
include("properties.jl")
include("semiringimpl.jl")
include("strings.jl")

end

