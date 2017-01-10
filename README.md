**Warning:** Wallace is currently in an non-functional state, following changes from Julia 0.3 onwards. For now, users are encouraged to seek other solutions.

# Wallace

Wallace is a high-performance, easy-to-use evolutionary computation framework written in [Julia](http://julialang.org/), built for researchers, students, and software engineers alike.
To simultaneously achieve performance and ease-of-use, Wallace utilises computational reflection to compile problem-specific data structures and algorithms at run-time, using a beautiful and compact domain-specific language.

Through its use of various programming techniques, and the thanks to the speed
of Julia, Wallace is both **the fastest evolutionary computation framework**,
beating ECJ and JCLEC, as well as **the most expressive and concise**, requiring
fewer lines of code to write than DEAP. For these reasons, Wallace makes both
a great framework for performing industrial-strength evolutionary computation
on highly complex real-world problems, as well as teaching its concepts.

**Features:**

* A compact, extensible domain-specific language.
* Multi-processing and multi-threading.
* Support for massively distributed computation.
* Just-in-time compilation of problem-optimised algorithms.
* Data logging, plotting and visualisation.
* An interactive shell, with an embedded documentation browser (via Julia).
* Modular structure makes it easy to extend and share components.

**Algorithms, Representations, and Operations:**

* Vectors, lists, sets, trees, orderings, etc.
* Grammatical evolution (efficient compilation to arbitrary languages).
* Genetic programming: Koza, Strictly-Typed GP, Grammar-Guided GP, PushGP, Cartesian GP.
* Multiple objective optimisation: NSGA, NSGA-II, SPEA, SPEA2, VEGA, and more.
* Co-operative and competitive co-evolution approaches.
* Island model support, for same and different species islands.

## Installation

The latest stable release of Wallace is most easily installed using Julia's package
manager within the REPL, as shown below.

```julia

$ julia
...

julia> Pkg.add("Wallace")
```

To install the latest developmental version of Wallace, open up the Julia REPL,
and call the following:

```julia
julia> Pkg.remove("Wallace")
julia> Pkg.clone("git://github.com/ChrisTimperley/Wallace.jl.git")
```

This will remove any existing Wallace module from your Julia installation,
before cloning the contents of the Wallace git repository into your local
Julia modules directory.

> Note: To avoid installation issues, ensure that the rest of your Julia packages are up-to-date via     `Pkg.update()`.

## Documentation and Tutorials

For technical documentation and an extensive set of tutorials, aimed at a wide range of different audiences, visit the Wallace website at: [http://www.christimperley.co.uk/Wallace.jl](http://www.christimperley.co.uk/Wallace.jl).

Up-to-date documentation and tutorials can be found at:
[wallacejl.readthedocs.org](http://wallacejl.readthedocs.org)

## Example

Below is the source code for the Max Ones benchmark problem provided in the
``examples`` package.

```julia
using Wallace

# Provide a definition for the algorithm.
def = algorithm.genetic() do alg
  alg.population = population.simple() do pop
    pop.size = 100

    # Species describes the fitness scheme and representation used by
    # individuals belonging to that species.
    pop.species = species.simple() do sp
      sp.fitness = fitness.scalar(Int)
      sp.representation = representation.bit_vector(100)
    end

    # Multi-threading breeding.
    pop.breeder = breeder.simple() do br
      br.threads = 8
      br.selection = selection.tournament(2)
      br.mutation = mutation.bit_flip(1.0)
      br.crossover = crossover.one_point(0.1)
    end
  end

  # Evaluation function (split across 8 threads).
  alg.evaluator = evaluator.simple(; threads = 8) do scheme, genome
    assign(scheme, sum(genome))
  end

  # Termination conditions.
  alg.termination = [criterion.generations(1000)]
end

# Compose the algorithm from its definition.
alg = compose!(def)

# Run the composed algorithm.
run!(alg)
```

## Citation

If you plan on using Wallace for your research, we encourage you to cite the
paper below. Additionally, put in a merge request, and we will add your paper
to the list of papers using Wallace.

```bibtex
@inproceedings{timperley2015wallace,
  author = {Timperley, Christopher Steven and Stepney, Susan},
  title = {Wallace: An efficient generic evolutionary framework},
  booktitle={ECAL 15},
  pages={365--372},
  year={2015},
  organization={MIT Press}
}
```
