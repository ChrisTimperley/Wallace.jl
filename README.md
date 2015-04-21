# Wallace

Wallace is a high-performance, easy-to-use evolutionary computation framework written in [Julia](http://julialang.org/), built for researchers, students, and software engineers alike.

**Installation:** ```julia> Pkg.add("Wallace")```

> Note: To avoid installation issues, ensure that the rest of your Julia packages are up-to-date via     `Pkg.update()`.

## Usage
To load an example problem in Wallace, simply follow the code below; a list of example problems can be found by calling the `examples()` function.

```julia
using Wallace

ex = example("max_ones")
results = run!(ex)
```
