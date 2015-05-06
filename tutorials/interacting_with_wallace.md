# Interacting with Wallace

## Navigational Commands

### `help` function

#### Describing types

```
julia> help("selection/tournament")
```

#### Describing type properties

```
julia> help("selection/tournament:size")
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
