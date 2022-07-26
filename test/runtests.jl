using Semirings
import LogExpFunctions: logaddexp
using Test

@testset "Strings" begin
    @test Semirings.longestcommonprefix("ab", "abc") == "ab"
    @test Semirings.longestcommonprefix("abc", "ab") == "ab"
    @test Semirings.longestcommonprefix("", "ab") == ""
    @test Semirings.longestcommonprefix("ab", "") == ""
    @test Semirings.longestcommonprefix("", "") == ""

    @test "ab" * ∞ == ∞
    @test ∞ * "ab" == ∞
    @test Semirings.longestcommonprefix(∞, "ab") == "ab"
    @test Semirings.longestcommonprefix("ab", ∞) == "ab"
end

@testset "Sequence monoid" begin
    x = one(SequenceMonoid)
    @test val(x) == tuple()

    a, b = SequenceMonoid(tuple(1)), SequenceMonoid(tuple("a"))
    @test val(a * b) == tuple(1, "a")

    @test SequenceMonoid((SubString("a"),)) == SequenceMonoid((String("a"),)) 
    @test SequenceMonoid((SubString("a"),)) in keys(Dict(SequenceMonoid((String("a"),)) => 1))
    @test SequenceMonoid((String("a"),)) in keys(Dict(SequenceMonoid((SubString("a"),)) => 1))
end

@testset "String monoid" begin
    x = one(StringMonoid)
    @test val(x) == ""

    a, b = StringMonoid("a"), StringMonoid("b")
    @test val(a * b) == "ab"
end

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

@testset "Product semiring" begin
    Ts = [BoolSemiring, LogSemiring, ProbSemiring,
          StringSemiring, TropicalSemiring, UnionConcatSemiring{StringMonoid},
          UnionConcatSemiring{SequenceMonoid}]

    for T1 in Ts, T2 in Ts
        T = ProductSemiring{T1,T2}
        x, y = zero(T), one(T)
        z = y + y
        @test x == ProductSemiring(zero(T1), zero(T2))
        @test y == ProductSemiring(one(T1), one(T2))
        @test z == ProductSemiring(one(T1) + one(T1), one(T2) + one(T2))
        @test z * z == ProductSemiring(z.val1 * z.val1, z.val2 * z.val2)
        @test conj(z) == z
        @test val(y) == (one(T1), one(T2))

        if IsOrdered(T1) == Ordered && IsOrdered(T2) == Ordered
            @test x < y <= z
        else
            @test_throws DomainError typemin(T)
            @test_throws DomainError typemin(one(T))
            @test_throws DomainError typemax(T)
            @test_throws DomainError typemax(one(T))
            @test_throws DomainError one(T) > one(T)
        end
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
    for T in [ProbSemiring{Float32}, LogSemiring{Float32},
              StringMonoid, SequenceMonoid]
        K = UnionConcatSemiring{T}
        @test issetequal(val(zero(K)), Set())
        @test issetequal(val(one(K)), Set(one(T)))

        if T == StringMonoid
            valx, valy = T("ab"), T("abc")
        elseif T == SequenceMonoid
            valx, valy = T(tuple(:a, :b)), T(tuple(:a, :b, :c))
        else
            valx, valy = T(0.5), T(0.5)
        end
        x = K(Set([valx]))
        y = K(Set([valy]))

        @test issetequal(val(x + y), union(val(x), val(y)))
        @test issetequal(val(x * (x + y)), union(val(x * x), val(x * y)))
        @test conj(x + y) == (x + y)
    end
end

@testset "Append-Concatenation semiring" begin
    for T in [ProbSemiring{Float32}, LogSemiring{Float32},
              StringMonoid, SequenceMonoid]
        K = AppendConcatSemiring{T}
        @test issetequal(val(zero(K)), T[])
        @test issetequal(val(one(K)), [one(T)])

        if T == StringMonoid
            valx, valy = T("ab"), T("abc")
        elseif T == SequenceMonoid
            valx, valy = T(tuple(:a, :b)), T(tuple(:a, :b, :c))
        else
            valx, valy = T(0.5), T(0.5)
        end
        x = K([valx])
        y = K([valy])

        @test all(val(x + y) .≈ vcat(val(x), val(y)))
        @test all(val(x * (x + y)) .≈ vcat(val(x * x), val(x * y)))
        @test conj(x + y) == (x + y)
    end
end

@testset "Semiring properties" begin
    Ts = [BoolSemiring, LogSemiring, ProbSemiring,
          StringSemiring, TropicalSemiring,
          UnionConcatSemiring{StringMonoid},
          UnionConcatSemiring{SequenceMonoid}]

    # Unordered semirings
    for T in filter(x -> IsOrdered(x) == Unordered, Ts)
        @test IsOrdered(T) == Unordered
        @test_throws DomainError typemin(T)
        @test_throws DomainError typemin(one(T))
        @test_throws DomainError typemax(T)
        @test_throws DomainError typemax(one(T))
        @test_throws DomainError one(T) > one(T)
    end

    # Ordered semirings
    for T in filter(x -> IsOrdered(x) == Ordered, Ts)
        @test IsOrdered(T) == Ordered
        @test one(T) > zero(T)
        @test maximum([T(2), T(3)]) == T(3)
    end

    # Not divisible semirings
    for T in filter(x -> IsDivisible == NotDivisible, Ts)
        @test IsDivisible(T) == NotDivisible
        @test_throws DomainError one(T) / one(T)
    end

    # Divisible semirings
    for T in filter(x -> IsDivisible == Divisible, Ts)
        @test IsDivisible(T) == Divisible
        @test one(T) ≈ (one(T) + one(T)) / (one(T) + one(T))
    end

    # Not idempotent semirings
    for T in filter(x -> IsIdempotent == NotIdempotent, Ts)
        @test IsIdempotent(T) == NotIdempotent
    end

    # Idempotent semirings
    for T in filter(x -> IsIdempotent == Idempotent, Ts)
        @test IsIdempotent(T) == Idempotent
        @test one(T) + one(T) ≈ one(T)
    end
end

@testset "General methods" begin
    Ts = [BoolSemiring, LogSemiring, ProbSemiring, StringSemiring,
          TropicalSemiring, UnionConcatSemiring{StringMonoid},
          UnionConcatSemiring{SequenceMonoid},
          UnionConcatSemiring{ProbSemiring{Float32}},
          AppendConcatSemiring{StringMonoid},
          AppendConcatSemiring{SequenceMonoid},
          AppendConcatSemiring{ProbSemiring{Float32}}]

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
        @test abs(x) == x && abs(y) == y
    end
end

