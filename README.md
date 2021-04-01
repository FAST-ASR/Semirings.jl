# SemifieldAlgebra.jl

SemifieldAlgebra.jl is a julia package (largely inspired from [SemiringAlgebra](https://github.com/JuliaComputing/SemiringAlgebra.jl)) 
which allows computations in an aribtrary [semifield](https://en.wikipedia.org/wiki/Semifield).

[![Test](https://github.com/lucasondel/SemifieldAlgebra.jl/actions/workflows/Test.yml/badge.svg)](https://github.com/lucasondel/SemifieldAlgebra.jl/actions/workflows/Test.yml)

## Installation

The package can be installed with the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run:

```julia
pkg> add SemifieldAlgebra
```

## Usage

First import the package:
```julia
julia> using SemifieldAlgebra
```
To create a specific semifield you need to specialize the `Semifield{T,A,M,MI,Z,O}` type where:
* `T` is the encoding type of the value, usually `Float32` or `Float64`
* `A` is the additive function
* `M` is the multiplicative function
* `MI` is the multiplicative inverse function
* `Z` is the "zero" element (additive identity)
* `O` is the "one" element (multiplicative identity)

For instance, here is how to create the Tropical semifield:
```julia
julia> const TropicalSemifield{T} = Semifield{T, max, +, -, -Inf, 0} where T
```

Numbers in a semifield are created and manipulated as follows:
```julia
julia> x = TropicalSemifield{Float64}(2)
julia> y = TropicalSemifield{Float64}(-2)
julia> x + y
2.0
```

The Semifield type can also be used with arrays:
```julia
julia> zeros(TropicalSemifield{Float64}, 3)
3-element Vector{Semifield{Float64, max, +, -, -Inf, 0}}:
 -Inf
 -Inf
 -Inf
```

## Author

Lucas Ondel ([website](https://lucasondel.github.io))
