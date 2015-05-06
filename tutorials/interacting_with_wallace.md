# Interacting with Wallace

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

```
julia> Wallace.version()
v"0.0.1"
```

### `examples` function
