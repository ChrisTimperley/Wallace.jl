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

Certain parameters within a file may require type information, in order to
instruct Wallace how to compile them. The most common way to do this is by
appending the property name with a type tag, enclosed in angled brackets,
as shown below:

```
selector<tournament>:
  size: 2
```

When the file is passed to the Wallace run-time, these type tags are simply
extracted from their property, and inserted as the `type` property within
its object. As such, you can avoid using type tags entirely by specifying
this type property directly, as demonstrated below:

```
selector:
  type: tournament
  size: 2
```

##### Absolute and Relative Types
In most cases, Wallace allows you to specify types either relative to some
namespace, or to give an absolute address for a given type. Below is an
example of a property that accepts types relative to the
`/selector/` namespace, and how a type may be specified using either
relative or absolute addressing:

```
selector<tournament>: { ... }
selector</selector/tournament>: { ... }
```

Absolute types are distinguished from relative types by Wallace using their
`\` prefix. When in doubt as to whether a given property supports relative
type addressing, you should consult the `help()` function for more information.

#### Lists

Lists can either be specified in a block format, where a hypen followed by
a space denotes each item within the list, as shown below:

```
colours:
  - red
  - yellow
  - blue
```

Alternatively, lists can be specified inline, by enclosing them within square
brackets and delimiting their items with a comma followed by a space:

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


