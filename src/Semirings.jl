# SPDX-License-Identifier: MIT

module Semirings

# Necessary for the logarithmic semiring
#import LogExpFunctions: logaddexp

# Strings extension
export StringZero
export ∞

# Monoids
export StringMonoid
export SequenceMonoid

# Semirings
export Semiring
export AppendConcatSemiring
export BoolSemiring
export LogSemiring
export ProbSemiring
export ProductSemiring
export StringSemiring
export TropicalSemiring
export UnionConcatSemiring, SymbolSequence
export val

# Semiring properties
export SemiringProperty
export IsDivisible, Divisible, NotDivisible
export IsIdempotent, Idempotent, NotIdempotent
export IsOrdered, Ordered, Unordered

include("monoidtype.jl")
include("monoidimpl.jl")
include("semiringtype.jl")
include("properties.jl")
include("semiringimpl.jl")
include("strings.jl")

end

