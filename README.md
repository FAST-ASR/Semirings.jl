# Semirings.jl

A julia package providing implementation of comomn [semirings](https://en.wikipedia.org/wiki/Semiring).

This package is largely inspired from [SemiringAlgebra](https://github.com/JuliaComputing/SemiringAlgebra.jl) and [mcognetta/Semirings.jl](https://github.com/mcognetta/Semirings.jl).


[![Test](https://github.com/FAST-ASR/Semirings.jl/actions/workflows/Test.yml/badge.svg)](https://github.com/FAST-ASR/Semirings.jl/actions/workflows/Test.yml)

## Installation

The package can be installed with the Julia package manager.
From the Julia REPL, type ] to enter the Pkg REPL mode and run:

```julia
pkg> add Semirings
```

## Example

Here is a brief example:
```julia
julia> using Semirings

julia> a, b = TropicalSemiring{Float64}(3), TropicalSemiring{Float64}(5)
(3.0, 5.0)

julia> a + b
5.0

julia> a * b
8.0

julia> x = ones(LogSemiring{Float64}, 2, 2)
2×2 Matrix{LogSemiring{Float64}}:
 0.0  0.0
 0.0  0.0

julia> x * x
2×2 Matrix{LogSemiring{Float64}}:
 0.693147  0.693147
 0.693147  0.693147

julia> x * x
2×2 Matrix{LogSemiring{Float64}}:
 0.693147  0.693147
 0.693147  0.693147
```

## Author

Lucas Ondel ([website](https://lucasondel.github.io))
