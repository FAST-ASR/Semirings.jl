# Lucas Ondel, 2021

using SemifieldAlgebra
using Test

const TropicalSemifield{T} = Semifield{T, max, +, -, -Inf, 0} where T
const _x = 1.6
const _y = -11.3

for T in [Float32, Float64]
    x = TropicalSemifield{T}(_x)
    y = TropicalSemifield{T}(_y)

    @test (x + y).val ≈ _x
    @test (x * y).val ≈ _x + _y
    @test (x / y).val ≈ _x - _y
    @test zero(typeof(x)).val == -Inf
    @test zero(TropicalSemifield{T}).val == -Inf
    @test one(typeof(x)).val == 0
    @test one(TropicalSemifield{T}).val == 0
end
