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
    @test IsDivisible(BoolSemiring) == NotDivisible()
    @test IsIdempotent(BoolSemiring) == Idempotent()
    @test IsOrdered(BoolSemiring) == Unordered()
end

@testset "Semiring properties" begin
    # Unordered semirings
    for T in [BoolSemiring]
        @test IsOrdered(T) == Unordered()
        @test_throws DomainError typemin(T)
        @test_throws DomainError typemin(one(T))
        @test_throws DomainError typemax(T)
        @test_throws DomainError typemax(one(T))
        @test_throws DomainError one(T) > one(T)
    end

    # Ordered semirings
    for T in [LogSemiring]
        @test IsOrdered(T) == Ordered()
        @test one(T) > zero(T)
    end

    # Not divisible semirings
    for T in [BoolSemiring]
        @test IsDivisible(T) == NotDivisible()
        @test_throws DomainError one(T) / one(T)
    end

    # Divisible semirings
    for T in [LogSemiring]
        @test IsDivisible(T) == Divisible()
        @test one(T) ≈ (one(T) + one(T)) / (one(T) + one(T))
    end

    # Not idempotent semiring
    for T in [LogSemiring]
        @test IsIdempotent(T) == NotIdempotent()
    end

    # Not idempotent semiring
    for T in [LogSemiring]
        @test IsIdempotent(T) == NotIdempotent()
    end
end


@testset "Logarithmic semiring" begin
    Ts = [Int64, Int32, Float64, Float32]

    for T in Ts
        @test iszero(one(LogSemiring{T}).val)
        @test zero(LogSemiring{T}).val == float(T)(-Inf)

    end

    for T1 in Ts, T2 in Ts
        x, y = LogSemiring(T1(2)), LogSemiring(T2(3))
        @test (x + y).val ≈ logaddexp(x.val, y.val)
        @test (x * y).val ≈ x.val + y.val
        @test (x / y).val ≈ x.val - y.val
        @test x <=  y
        @test IsDivisible(LogSemiring) == Divisible()
        @test IsIdempotent(LogSemiring) == NotIdempotent()
        @test IsOrdered(LogSemiring) == Ordered()
    end
end

