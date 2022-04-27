# Releases

## 0.2.2

* bugfix: `K(true / false)` does not give the semiring 1 / 0.
* bugfix: `oneunit(x)` failing due to the impossibility to build
  a semiring number from another semiring number
* bugfix: `conj(x)` returning the identity function for the
  Union-Concatenation semiring.

## 0.2.1

* bugfix: `iszero(x)` not returning the semiring zero

## 0.2.0

* rename the package from `SemifieldAlgebra` to `Semirings`

## 0.1.0

* initial release
