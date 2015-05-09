# Interacting with Wallace

## Modes of Interaction

### Julia Read-Eval-Print-Loop (REPL)

```
shell> julia
...
...

julia> using Wallace
```

### IJulia Graphical Notebook

```
julia> using IJulia
julia> notebook()
```

```
shell> ipython notebook --profile julia
```


### Script Execution

```
shell> julia my_script.jl
```

-------------------------------------------------------------------

## Loading Wallace Files

```
julia> alg = compose("my_algorithm.cfg")
```

```
julia> alg = compose_as("my_algorithm.cfg", "algorithm/simple_evolutionary_algorithm")
```

```
julia> alg = compose_with("my_algorithm.cfg") do cfg
  cfg["population_size"] = 100
end

julia> alg = compose_as_with("my_algorithm.cfg", "algorithm/simple_evolutionary_algorithm") do cfg
  cfg["population_size"] = 100
end
```
-------------------------------------------------------------------

## Navigational Commands

### `help` function

#### Describing types

```
julia> help("selection/tournament")

Authors: Alice and Bob
```

#### Describing type properties

```
julia> help("selection/tournament:size")
The number of individuals that should participate in each tournament.

Type:     Integer
Default:  5
```

### `listall` function

The `listall` function can be used to produce a list of all the known
sub-types of a given type that have been loaded into the Wallace
environment.

```
julia> listall("selection")
- selection/tournament
- selection/roulette
- selection/stochastic_universal_sampling
- selection/random
- selection/truncation
```

### `aliases` function
The `aliases` function returns a list of all known aliases for a given property
or type.

```
julia> aliases("selection/stochastic_universal_sampling")
- selection/stochastic_universal_sampling
- selection/sus

julia> aliases("mutation/bit_flip#rate")
- #rate
- #probability
```

### `version` function

To see which version of Wallace you're running on your system, you may make use
of the provided `version` function.

```
julia> Wallace.version()
v"0.0.1"
```

### `examples` function
The `examples` function can be used to return a list of all the official
example solutions bundled with your current version of Wallace.

```
julia> Wallace.examples()
- ant
- koza
- multiplexer
- one_max
- rastrigin
- symbolic_regression
```

To load the algorithm for one of these examples, one may use the
`example` function with the name of the example problem you wish to build:

```
julia> alg = Wallace.example("ant");
julia> results = run!(alg);
```
