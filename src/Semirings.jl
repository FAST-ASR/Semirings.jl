# SPDX-License-Identifier: MIT

module Semirings

# Necessary for the logarithmic semiring
import LogExpFunctions: logaddexp

# Semirings
export Semiring
export BoolSemiring
export LogSemiring
export ProbSemiring
export TropicalSemiring
export UnionConcatSemiring

# Semiring properties
export SemiringProperty
export IsDivisible, Divisible, NotDivisible
export IsIdempotent, Idempotent, NotIdempotent
export IsOrdered, Ordered, Unordered

include("semiringtype.jl")
include("properties.jl")
include("semiringimpl.jl")

end

