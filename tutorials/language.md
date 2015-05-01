# Wallace Specification Language
#### An overview of the Wallace specification language.

--------------------------------------------------------------------------------
### An Example File

```
<algorithm/simple_evolutionary_algorithm>:
  evaluator<simple>:
    objective: >
      SimpleFitness{Int}(true, sum(get(i.bits))

  replacement<generational>:
    elitism: 0

  termination[iterations<iterations>]: { limit: 1000 }

  _my_species:
    stages[bits]:
      representation<bit_vector>: { length: 100 }

  _my_breeder<fast>:
    sources[s]<selection>:
      operator<selection/tournament>: { size: 2 }

    sources[x]<variation>:
      source: s
      stage: bits
      operator<crossover/one_point>: { rate: 1.0 } 

    sources[m]<variation>:
      source: x
      stage: bits
      operator<mutation/bit_flip>: { rate: 0.1 }

  population:
    demes:
      - capacity: 100
        species: $(_my_species)
        breeder: $(_my_breeder)
```

--------------------------------------------------------------------------------
### Language Features

#### Top-Level Structure

#### Types

#### Multi-Line Descriptions

#### Lists

```
colours:
  - red
  - yellow
  - blue
```

```
[red, yellow, blue, green]
```

#### Indexed Collections

#### Pointers

#### Comments

```
# Comments can take up a whole line,
x: 30 # or just the end of a line.

  # And indentation doesn't matter,
            # at all.
```


