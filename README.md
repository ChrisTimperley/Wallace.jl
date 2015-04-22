# Wallace

Wallace is a high-performance, easy-to-use evolutionary computation framework written in [Julia](http://julialang.org/), built for researchers, students, and software engineers alike.
To simultaneously achieve performance and ease-of-use, Wallace utilises computational reflection to compile problem-specific data structures and algorithms at run-time, using a beautiful and compact domain-specific language.

**Installation:** ```julia> Pkg.add("Wallace")```

> Note: To avoid installation issues, ensure that the rest of your Julia packages are up-to-date via     `Pkg.update()`.

## Documentation and Tutorials

For technical documentation and an extensive set of tutorials, aimed at a range of different audiences, visit the Wallace website at: [http://www.christimperley.co.uk/Wallace](http://www.christimperley.co.uk/Wallace).

## Usage
To load an example problem in Wallace, simply follow the code below; a list of example problems can be found by calling the `examples()` function.

```julia
using Wallace

ex = example("max_ones")
results = run!(ex)
```
