# Semirings.jl

A julia package (largely inspired from [SemiringAlgebra](https://github.com/JuliaComputing/SemiringAlgebra.jl) and [mcognetta/Semirings.jl](https://github.com/mcognetta/Semirings.jl))
which provides implementation of common [semirings](https://en.wikipedia.org/wiki/Semiring).

[![Test](https://github.com/FAST-ASR/Semirings.jl/actions/workflows/Test.yml/badge.svg)](https://github.com/FAST-ASR/Semirings.jl/actions/workflows/Test.yml)

## Installation

The package can be installed with the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run:

```julia
pkg> add Semirings
```

## Usage

First import the package:
```julia
julia> using Semirings
```
To create a specific semiring you need to specialize the `Semiring{T,A,M,MI,Z,O}` type where:
* `T` is the encoding type of the value, usually `Float32` or `Float64`
* `A` is the additive function
* `M` is the multiplicative function
* `MI` is the multiplicative inverse function
* `Z` is the "zero" element (additive identity)
* `O` is the "one" element (multiplicative identity)

For instance, here is how to create the Tropical semiring:
```julia
julia> const TropicalSemiring{T} = Semiring{T, max, +, -, -Inf, 0} where T
```

Numbers in a semiring are created and manipulated as follows:
```julia
julia> x = TropicalSemiring{Float64}(2)
julia> y = TropicalSemiring{Float64}(-2)
julia> x + y
2.0
```

The Semiring type can also be used with arrays:
```julia
julia> zeros(TropicalSemiring{Float64}, 3)
3-element Vector{Semiring{Float64, max, +, -, -Inf, 0}}:
 -Inf
 -Inf
 -Inf
```

## Author

Lucas Ondel ([website](https://lucasondel.github.io))
