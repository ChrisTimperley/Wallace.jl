# Wallace

## Installation
Wallace is installed using Julia's built-in package manager system, via the `Pkg.add("Wallace")` command; before calling this however, ensure that the rest of your packages are up-to-date, via `Pkg.update()`.

    julia> Pkg.init()
    julia> Pkg.update()
    julia> Pkg.add("Wallace")

## Usage
To load an example problem in Wallace, simply follow the code below. For a list of example problems, simply call the `examples()` function.

```julia
using Wallace

ex = example("max_ones")
results = run!(ex)
```
