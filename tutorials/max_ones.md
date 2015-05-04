# Max Ones
### An Introduction to Solving Optimisation Problems with Genetic Algorithms

**Author:** [Chris Timperley](http://www.christimperley.co.uk),
**Difficulty:** Beginner,
**Duration:** 15-30 minutes.

In this tutorial, we will be using Wallace to implement a simple Genetic
Algorithm to solve the benchmark Max Ones optimisation problem, where we attempt
to maximise the number of 1s in a fixed-length bit-string. This problem is
trivial for humans, of course, but proves to be a little trickier for "blind"
evolutionary algorithms.

**This tutorial assumes:**

* A minimal knowledge of [Julia](http://julialang.org/).
* You know how to navigate the Julia REPL when using Wallace.
* You know how to load Wallace specification files and run them.
* You know a little bit about the basic structure of Wallace specification files. 

**By the end of this tutorial, you will be able to:**

* Write a simple binary-string genetic algorithm from scratch.
* Use Wallace to solve simple binary-string optimisation problems, such as the
  Max Ones problem.

--------------------------------------------------------------------------------

#### Creating a skeleton for our specification file.
To start off with, let's create an empty Wallace specification file within our
current working directory, called `my_max_ones.cfg`. Now let's open up our
skeleton specification in your favourite text editor and start writing a simple
GA to solve our problem.

> **Tip:** If you're running Wallace through the Julia REPL, try using *shell
  mode* by typing ";" into the console; this will allow your to access
  command-line text editors such as `vim` and `nano` from within the REPL
  session.

To begin with, we need to specify the type of the object that we wish our
specification to describe. In this case, we'll be using our specification to
describe a *simple evolutionary algorithm* to, so we prepend the
`algorithm/simple_evolutionary_algorithm` type to the front of our description
in order to let Wallace know how we want the object to be built.

```
type: algorithm/simple_evolutionary_algorithm
```

> **What happens if you  omit the type of the root object in the specification
  file?**
  <br/>
  Then Wallace will be unable to construct the object when you call
  `compose(my_specification)`. However, you can still force Wallace to
  construct as if it were a given type by using
  `compose_as(my_specification, some_type)`.


#### Specifying the components of our algorithm.
Now we have a skeleton for our algorithm specification in place, let's go about
specifying each of the components and parameters of our algorithm. Before we
can do this, we need to know more about the structure and properties of the
`algorithm/simple_evolutionary_algorithm` type; in order to find out this
information, we can call the `properties` or `help` function, as demonstrated
below:

```
julia> help("algorithm/simple_evolutionary_algorithm")

Properties:
- evaluator
- replacement
- termination
- population

julia> help("algorithm/simple_evolutionary_algorithm:evaluator")

The method of evaluating individuals used by this algorithm.
```

> **Tip:** If you're running Wallace through the Julia REPL, try using
  *help mode* by typing "?" into the console. Once in help mode, simply type
  the name of the Wallace or Julia type you wish to know more about.

#### Setting up the population.

To begin with, let's make use of the look-up operator, *$*, in order to specify
the population setup used by our algorithm. By default, the standard `population`
type within Wallace is composed of a number of demes (also known as sub-populations),
each of which undergoes its own evolutionary processes in isolation, perhaps running
on its own compute node.

Following the example below, we can create a single-deme population, composed of
100 individuals of a single species and using a given breeding setup, both defined
elsewhere within the file.

```
algorithm/simple_evolutionary_algorithm {
  population:
    demes:
      - size: 100, species: $(_my_species), breeder: $(_my_breeder)
}
```

#### Setting up the species and representation.

Now we have our single deme population in place, let's go about specifying its
species and the representation used by its members, by specifying the
`_my_species` property we referenced earlier. In order to find out what
information we need to provide our species definition with, we can once again
make use of `help("species")` to find out more information about a given type,
as demonstrated below:

```
julia> help("species")

Properties:
- stages

julia> help("species:stages")

An indexed collection describing each of the different stages of development
for an individual belonging to this species, indexed by the name of the
developmental stage.

Type: IndexedCollection{String, species_stage}
```

As we can see from above, species are represented by a series of developmental
stages; this is one of the features unique to Wallace. For a lot of problems,
we're only interested in using a single stage to represent the genome, but for
more complex setups, such as grammatical evolution, we model the individual
using a sequence of representations.

Using the `help()` function, find out the structure of `species_stage`
definitions, before composing one for your algorithm specification. In this
tutorial we won't be discussing how more complex multiple stage species are
composed.

```
julia> help("species_stage")

Describes a particular stage of individual development for a given species.

Properties:
- Representation
- From
- Lamarckian
```

For our simple, single-stage problem, the only parameter we need to concern
ourselves with is the `representation` parameter, which describes the
representation used by this stage of development; in the case of this problem,
we'll be using a bit vector. In order to find the appropriate type of
`representation` for our problem, try using the `listall("PARENT_TYPE")`
function to list all known representations registered with Wallace, before
using `help()` to figure out what parameters to supply it with.

Once you've done that, your species definition should look something like the
one below:

```
...
  _my_species:
    stages[bits]:
      representation: representation/bit_vector { length: 100 }
...
```

#### Specifying the breeding operations.

Now we have the species of our single deme in place, let's go about specifying
the breeding operations responsible for producing the offspring for our deme
at each generation. For this problem, we will be implementing a single method
of selection, mutation and recombination, however, you may produce any
arbitrary chain of operations that you wish.

To describe these operations, we use a `breeder` component; in this case we'll
be using the default `breeder/fast` breeder. The breeder is composed of a
number of sources, provided to its `sources` collection. For this problem we'll
be using `selection` sources to implement our selection methods, and `variation`
sources to implement our methods of crossover and mutation.

Each breeder source accepts a single `operator`, and in the case of variation
methods, it also accepts a `stage` property, specifying which stage of the
individual the operator is applied to. Variation sources also accept a `source`
parameter, informing the breeder which source should be used to provide inputs.

An example breeder setup is given below. Using the `listall()` and `help()`
functions, try to build your own selection-crossover-mutation breeding sequence.

```
...
  _my_breeder: breeder/fast
    sources[s]: selection
      operator: selection/tournament { size: 2 }
    sources[x]: variation
      operator: crossover/one_point { rate: 1.0 }
      source: "s"
      stage: "bits"
    sources[m]: variation
      operator: mutation/bit_flip { rate: 0.1 }
      source: "x"
      stage: "bits"
...
```

> **Why doesn't the selector specify a source or stage?**
  <br/>
  The selector operates on individuals as a whole, considering only their
  fitness values; no changes are made to the individual. No source is
  required as the selector uses the contents of the deme it is connected
  to as its source.

> **What happens if I omit the `stage` property for a variation operator?**
  <br/>
  Wallace will assume the operator acts upon the canonical genome of an
  individual (rather than any of its other stages). Removing the `stage`
  property for this example should have no effect.

> **What happens if I omit the `source` property for a variation operator?**
  <br/>
  The breeder will fail to compile and will raise an error.

> **Are there types of breeder sources other than `selection` and `variation`?**
  <br/>
  Another less common type of breeder source is the `multi` source, which draws
  a requested number of individual from a number of attached breeding sources.
  The number of individuals picked from each source may be based on either fixed
  proportions or a given probability distribution.

#### Setting up the evaluator.
Next, let's provide an evaluation function for algorithm so that we can assess
the relative fitness of potential solutions. For this problem, you should use
the `evaluator/simple` evaluator, which simply computes the fitness of each
individual within a given population using a provided `objective` function.

This objective function will be implemented as a Julia function, accepting a
single candidate individual, `i`, and producing a `Fitness` object containing
its calculated objective value. In order to provide a Julia function to the
Wallace specification language, we simply need to prepend `->` onto the start
of our objective definition, immediately after the opening colons; this
instructs Wallace to treat all the code within the block below as a single
function definition, and not as a specification.

To calculate the fitness of a candidate individual for our given problem, we
need to count the number of binary 1s within the `bits` stage of the given
individual. In order to access the candidate's bits stage, we simply call
`get(i.bits)`. We can then calculate the number of ones within this string
by simply summing it using Julia's `sum` function. Finally, we wrap our
computed objective value within a new `SimpleFitness` object, and specify
that the objective should be maximised by setting its first parameter to
`true`.

```
...
  evaluator: evaluator/simple
    objective: ->
      SimpleFitness{Int}(true, sum(get(i.bits)))
...
```

> **Why do I have to call `get(i.bits)` rather than `i.bits`?**
  <br/>
  `i.bits` stores an `IndividualStage` object that acts as a lightweight proxy
  to the value of a given stage. This proxy is required to avoid illegally
  accessing an undefined stage. Although this feature serves little use in
  this example, it becomes critical when performing grammatical evolution,
  where the latter stages of an individual may fail to generate.

> **How do I check if a given stage is safe to access?**
  <br/>
  By simply calling `issafe(i.NAME)`, where `NAME` is replaced by the name of
  the stage you wish to check; if the stage is safe to access, the function
  will return `true`, else it will return `false`.

#### Specifying the termination conditions.

Finally, provide your algorithm specification with a set of termination
conditions, implemented using the `termination` hash, as shown in the example
below. Once the state of the algorithm has satisfied any of these conditions, it
will terminate before the start of the next iteration. For now, let's specify
a simple limit on the number of iterations that the algorithm may run for.

```
...
  termination[iterations]: criterion/iterations { limit: 100 }
...
```

> **What happens if I don't supply any termination conditions?**
  <br/>
  The algorithm won't terminate until you force the program to close;
  we don't advise doing this!

> **What other types of termination condition are there?**
  <br/>
  Call `listall("termination")` from within the REPL to produce a list of all
  known termination condition types registered with Wallace. To find out more
  about a particular type, just call `help("name_of_type")` in the REPL.

#### Running the algorithm and analysing the results.

> **Question:** *Does the fitness of the best individual in the population
  always improve or stay the same?*


#### Optimising our algorithm parameters.

-------------------------------------------------------------------------------

## Troubleshooting
