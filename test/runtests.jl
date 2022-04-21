using Semirings
import LogExpFunctions: logaddexp
using Test

@testset "Boolean semiring" begin
    x, y = one(BoolSemiring), zero(BoolSemiring)
    @test x.val # one is true
    @test !y.val # zero is false
    @test (x + y).val
    @test (x + x).val
    @test !(y + y).val
    @test !(x * y).val
    @test (x * x).val
    @test !(y * y).val
end

@testset "Logarithmic semiring" begin
    Ts = [Int64, Int32, Float64, Float32]

    @test one(LogSemiring).val == float(Real)(0)
    @test zero(LogSemiring).val == float(Real)(-Inf)
    for T in Ts
        @test one(LogSemiring{T}).val == float(T)(0)
        @test zero(LogSemiring{T}).val == float(T)(-Inf)
    end

    for T1 in Ts, T2 in Ts
        x, y = LogSemiring(T1(2)), LogSemiring(T2(3))
        @test (x + y).val ≈ logaddexp(x.val, y.val)
        @test (x * y).val ≈ x.val + y.val
        @test (x / y).val ≈ x.val - y.val
        @test x <=  y
    end
end

@testset "Probability semiring" begin
    Ts = [Int64, Int32, Float64, Float32]

    @test one(ProbSemiring).val == one(float(Real))
    @test zero(ProbSemiring).val == zero(float(Real))
    for T in Ts
        @test one(ProbSemiring{T}).val == one(float(T))
        @test zero(ProbSemiring{T}).val == zero(float(T))
    end

    for T1 in Ts, T2 in Ts
        x, y = ProbSemiring(T1(2)), ProbSemiring(T2(3))
        @test (x + y).val ≈ x.val + y.val
        @test (x * y).val ≈ x.val * y.val
        @test (x / y).val ≈ x.val / y.val
        @test x <=  y
    end
end

@testset "Tropical semiring" begin
    Ts = [Int64, Int32, Float64, Float32]

    @test one(TropicalSemiring).val == float(Real)(0)
    @test zero(TropicalSemiring).val == float(Real)(-Inf)
    for T in Ts
        @test one(TropicalSemiring{T}).val == float(T)(0)
        @test zero(TropicalSemiring{T}).val == float(T)(-Inf)
    end

    for T1 in Ts, T2 in Ts
        x, y = TropicalSemiring(T1(2)), TropicalSemiring(T2(3))
        @test (x + y).val ≈ max(x.val, y.val)
        @test (x * y).val ≈ x.val + y.val
        @test (x / y).val ≈ x.val - y.val
        @test x <=  y
    end
end

@testset "Union-Concatenation semiring" begin
    @test issetequal(zero(UnionConcatSemiring).val, Set())
    @test issetequal(one(UnionConcatSemiring).val, Set([SymbolSequence()]))

    valx, valy = SymbolSequence([:a, :b]), SymbolSequence([:a, :b, :c])
    @test UnionConcatSemiring(valx) == UnionConcatSemiring(Set([valx]))

    x, y = UnionConcatSemiring(valx), UnionConcatSemiring(valy)
    @test issetequal((x + y).val, union(Set([valx]), Set([valy])))

    z = UnionConcatSemiring(Set([
            SymbolSequence([:a, :b, :a, :b]),
            SymbolSequence([:a, :b, :a, :b, :c])]))

    @test issetequal((x * (x + y)).val, z.val)
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
    end
end

