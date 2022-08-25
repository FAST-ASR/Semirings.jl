# Releases

## [0.5.4](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.5.5) - 26.07.2022
### Fixed
- using faster implementation of `logaddexp` function (with small loss
  of accuracy).
  
## [0.5.4](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.5.4) - 26.07.2022
### Fixed
- `hash` not defined for `Semiring` nor for `Monoid` leading to a search issues.

## [0.5.3](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.5.3) - 08.06.2022
### Fixed
- `convert(., .)` works in both direction from/to semiring/number for
  numeric type semirings

## [0.5.2](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.5.2) - 08.06.2022
### Fixed
- `isless(x, y)` not defined for `Ordered` semirings (e.g. LogSemiring, TropicalSemiring,...)

## [0.5.1](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.5.1) - 08.06.2022
### Added
- compatibility with Julia 1.6

## [0.5.0](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.5.0) - 01.06.2022
### Added
- append-concatenation semiring (`AppendConcat`), similar to
  union-concatenation but with list concatentation instead of union
  of set
- monoid types: `StringMonoid` and `SequenceMonoid` that are used to
  specialize `UnionConcat` and `AppendConcat` semirings

## [0.4.0](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.4.0) - 20.05.2022
### Added
- added the `ProductSemiring`, i.e. the combination of two semirings
- added the `StringSemiring`
### Changed
- The Union-Concatenation semiring is now restricted to work on strings
  and not arbitrary sequences
### Fixed
- Removed the `UnionAll` in the `show` method. This type signature was
  causing printing issue with the PythonCall package.

## [0.3.0](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.3.0) - 04.05.2022
### Added
- `val(x)` function to access the value of the semiring number
- `abs(x)` return `x` for semiring values

### Fixed
- `K(true / false)` does not give the semiring 1 / 0
- `oneunit(x)` failing due to the impossibility to build
  a semiring number from another semiring number
- `conj(x)` returning the identity function for the Union-Concatenation
  semiring.

## [0.2.1](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.2.1) - 25.04.2022
### Fixed
- `iszero(x)` not returning the semiring zero

## [0.2.0](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.2.0) - 23.04.2022
### Changed
- rename the package from `SemifieldAlgebra` to `Semirings`

## [0.1.0](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.1.0) - 04.04.2021
- initial release
