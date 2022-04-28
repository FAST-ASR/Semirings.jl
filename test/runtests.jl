using Semirings
import LogExpFunctions: logaddexp
using Test

@testset "Boolean semiring" begin
    x, y = one(BoolSemiring), zero(BoolSemiring)
    @test val(x) # one is true
    @test ! val(y) # zero is false
    @test val(x + y)
    @test val(x + x)
    @test !  val(y + y)
    @test ! val(x * y)
    @test val(x * x)
    @test ! val(y * y)
end

@testset "Logarithmic semiring" begin
    Ts = [Int64, Int32, Float64, Float32]

    @test val(one(LogSemiring)) == float(Real)(0)
    @test val(zero(LogSemiring)) == float(Real)(-Inf)
    for T in Ts
        @test val(one(LogSemiring{T}))  == float(T)(0)
        @test val(zero(LogSemiring{T})) == float(T)(-Inf)
    end

    for T1 in Ts, T2 in Ts
        x, y = LogSemiring(T1(2)), LogSemiring(T2(3))
        @test val(x + y) ≈ logaddexp(val(x), val(y))
        @test val(x * y) ≈ val(x) + val(y)
        @test val(x / y) ≈ val(x) - val(y)
        @test x <=  y
    end
end

@testset "Probability semiring" begin
    Ts = [Int64, Int32, Float64, Float32]

    @test val(one(ProbSemiring)) == one(float(Real))
    @test val(zero(ProbSemiring)) == zero(float(Real))
    for T in Ts
        @test val(one(ProbSemiring{T})) == one(float(T))
        @test val(zero(ProbSemiring{T})) == zero(float(T))
    end

    for T1 in Ts, T2 in Ts
        x, y = ProbSemiring(T1(2)), ProbSemiring(T2(3))
        @test val(x + y) ≈ val(x) + val(y)
        @test val(x * y) ≈ val(x) * val(y)
        @test val(x / y) ≈ val(x) / val(y)
        @test x <=  y
    end
end

@testset "Tropical semiring" begin
    Ts = [Int64, Int32, Float64, Float32]

    @test val(one(TropicalSemiring)) == float(Real)(0)
    @test val(zero(TropicalSemiring)) == float(Real)(-Inf)
    for T in Ts
        @test val(one(TropicalSemiring{T})) == float(T)(0)
        @test val(zero(TropicalSemiring{T})) == float(T)(-Inf)
    end

    for T1 in Ts, T2 in Ts
        x, y = TropicalSemiring(T1(2)), TropicalSemiring(T2(3))
        @test val(x + y) ≈ max(val(x), val(y))
        @test val(x * y) ≈ val(x) + val(y)
        @test val(x / y) ≈ val(x) - val(y)
        @test x <=  y
    end
end

@testset "Union-Concatenation semiring" begin
    @test issetequal(val(zero(UnionConcatSemiring)), Set())
    @test issetequal(val(one(UnionConcatSemiring)), Set([SymbolSequence()]))

    valx, valy = SymbolSequence([:a, :b]), SymbolSequence([:a, :b, :c])
    @test UnionConcatSemiring(valx) == UnionConcatSemiring(Set([valx]))

    x, y = UnionConcatSemiring(valx), UnionConcatSemiring(valy)
    @test issetequal(val(x + y), union(Set([valx]), Set([valy])))

    z = UnionConcatSemiring(Set([
            SymbolSequence([:a, :b, :a, :b]),
            SymbolSequence([:a, :b, :a, :b, :c])]))

    @test issetequal(val(x * (x + y)), val(z))

    @test conj(x + y) == (x + y)
end

@testset "Semiring properties" begin
    # Unordered semirings
    for T in [BoolSemiring, UnionConcatSemiring]
        @test IsOrdered(T) == Unordered()
        @test_throws DomainError typemin(T)
        @test_throws DomainError typemin(one(T))
        @test_throws DomainError typemax(T)
        @test_throws DomainError typemax(one(T))
        @test_throws DomainError one(T) > one(T)
    end

    # Ordered semirings
    for T in [LogSemiring, ProbSemiring, TropicalSemiring]
        @test IsOrdered(T) == Ordered()
        @test one(T) > zero(T)
    end

    # Not divisible semirings
    for T in [BoolSemiring, UnionConcatSemiring]
        @test IsDivisible(T) == NotDivisible()
        @test_throws DomainError one(T) / one(T)
    end

    # Divisible semirings
    for T in [LogSemiring, ProbSemiring, TropicalSemiring]
        @test IsDivisible(T) == Divisible()
        @test one(T) ≈ (one(T) + one(T)) / (one(T) + one(T))
    end

    # Not idempotent semirings
    for T in [LogSemiring, ProbSemiring]
        @test IsIdempotent(T) == NotIdempotent()
    end

    # Idempotent semirings
    for T in [BoolSemiring, TropicalSemiring, UnionConcatSemiring]
        @test IsIdempotent(T) == Idempotent()
        @test one(T) + one(T) ≈ one(T)
    end
end

@testset "General methods" begin
    Ts = [BoolSemiring, LogSemiring, ProbSemiring, TropicalSemiring,
          UnionConcatSemiring]

    for T in Ts
        x = ones(T, 10)
        @test all(x .≈ (x')')
    end

    for T in Ts
        x, y = zero(T), one(T)
        @test zero(T) == zero(x)
        @test iszero(x)
        @test ! iszero(y)
        @test one(T) == one(y)
        @test ! isone(x)
        @test isone(y)
        @test oneunit(x) == T(one(x))
        @test isone(y * true) && isone(true * y)
        @test iszero(y * false) && iszero(false * y)
    end
end

