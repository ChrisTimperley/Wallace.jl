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

```json
algorithm/simple_evolutionary_algorithm {

}
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
- representation
```

Find list of representations.

```
julia> help("species:representation")

Describes the data structure used to represent solutions for this given species.

Type: representation
```

Fill in the specification file.

```
...
  _my_species:
    stages[bits]:
      representation: representation/bit_vector { length: 100 }
...
```

#### Specifying the breeding operations.

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

#### Setting up the evaluator.

```
...
  evaluator: evaluator/simple
    objective: ->
      SimpleFitness{Int}(true, sum(get(i.bits)))
...
```

#### Specifying the termination conditions.

Finally, provide your algorithm specification with a set of termination
conditions, implemented using the `termination` hash, as shown in the example
below. Once the state of the algorithm has satisfied any of these conditions,
the algorithm will terminate. For now, let's specify a simple limit on the
number of iterations that the algorithm may run for.

```
...
  termination[iterations]: criterion/iterations { limit: 100 }
...
```

> **What happens if I don't supply any termination conditions?**
  <br/>
  The algorithm won't terminate until you force the program to close;
  we don't advise doing this!

> **What other termination conditions are there?**
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
