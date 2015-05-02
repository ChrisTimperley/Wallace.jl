# Wallace Specification Language
#### An overview of the Wallace specification language.

--------------------------------------------------------------------------------
### An Example File

```
type: algorithm/simple_evolutionary_algorithm:

evaluator<simple>:
  objective: |
    SimpleFitness{Int}(true, sum(get(i.bits))

replacement<generational>: { elitism: 0 }

termination:
  iterations<iterations>: { limit: 1000 }

_my_species:
    stages:
      bits: { representation<bit_vector>: { length: 100 } }

_my_breeder<fast>:
  sources:
    sel<selection>:
      operator<tournament>: { size: 2 }

    crx<crossover>:
      source: sel
      stage:  bits
      operator<one_point>: { rate: 1.0 } 

    mut<mutation>:
      source: crx
      stage:  bits
      operator<bit_flip>: { rate: 0.1 }

population:
  demes:
    - capacity: 100
      species: $(_my_species)
      breeder: $(_my_breeder)
```

--------------------------------------------------------------------------------
### Language Components

#### Top-Level Structure

```
type: algorithm/evolutionary_algorithm
```

#### Type Labels

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

#### Associative Arrays

```
  model:  Forza Corsa
  colour: Red
  year:   2011
```

```
{model: Forza Corsa, colour: Red, year: 2011}
```

#### Multi-Line Descriptions

#### Pointers

#### Comments

```
# Comments can take up a whole line,
x: 30 # or just the end of a line.

  # And indentation doesn't matter,
            # at all.
```


