# Wallace Specification Language
#### An overview of the Wallace specification language.

--------------------------------------------------------------------------------
### An Example File

Below is an example specification file for an implementation of the OneMax
problem, using the `simple_evolutionary_algorithm` type.

```
type: algorithm/simple_evolutionary_algorithm

evaluator<simple>:
  objective: |
    SimpleFitness{Int}(true, sum(get(i.bits))

replacement<generational>: { elitism: 0 }

termination:
  iterations<iterations>: { limit: 1000 }

species:
  representation<bit_vector>: { length: 100 }

breeder:
  selector<tournament>: { size: 2 }
  crossover<one_point>: { rate: 1.0 } 
  mutation<bit_flip>:   { rate: 0.1 }

population_size: 100
```

--------------------------------------------------------------------------------
### Language Components

#### Top-Level Structure

All specification files should contain a top-level `type` parameter, stipulating
the type of object described by the file. Failing to provide a `type` parameter
will cause Wallace to be unable to compose the object via the `compose(FILE)`
function; however, the object can still be constructing by forcing it to be
constructed as a given type, using `compose_as(FILE, TYPE)`.

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


