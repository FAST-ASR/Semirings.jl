# Releases

## 0.4.0
## Added
- added the `StringSemiring`
## Changed
- The Union-Concatenation semiring is now restricted to work on strings
  and not arbitrary sequences
### Fixed
- Removed the `UnionAll` in the `show` method. This type signature was
  causing printing issue with the PythonCall package.

## [0.3.0](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.3.0) - 2022.05.04
### Added
- `val(x)` function to access the value of the semiring number
- `abs(x)` return `x` for semiring values

### Fixed
- `K(true / false)` does not give the semiring 1 / 0
- `oneunit(x)` failing due to the impossibility to build
  a semiring number from another semiring number
- `conj(x)` returning the identity function for the Union-Concatenation
  semiring.

## [0.2.1](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.2.1) - 2022.04.25
### Fixed
- `iszero(x)` not returning the semiring zero

## [0.2.0](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.2.0) - 2022.04.23
### Changed
- rename the package from `SemifieldAlgebra` to `Semirings`

## [0.1.0](https://github.com/FAST-ASR/Semirings.jl/releases/tag/v0.1.0) - 2021.04.04
- initial release
