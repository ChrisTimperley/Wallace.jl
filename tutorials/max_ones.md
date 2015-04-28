# Max Ones
### An Introduction to Solving Optimisation Problems with Genetic Algorithms

**Author:** [Chris Timperley](http://www.christimperley.co.uk),
**Difficulty:** Beginner,
**Duration:** 10-30 minutes.

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

> **What If:** If you omit the type of the root object in your specification
  file, then Wallace will be unable to construct the object when you call
  `compose(my_specification)`. However, you can still force Wallace to
  construct as if it were a given type by using
  `compose_as(my_specification, some_type)`.

#### Specifying the components of our algorithm.

```
algorithm/simple_evolutionary_algorithm {
  evaluator: evaluator/simple
    objective: (i) -> SimpleFitness{Int}(true, sum(get(i.bits)))
  
  replacement: replacement/generational
}
```


#### Running our algorithm and analysing our results.

> **Question:** *Does the fitness of the best individual in the population
  always improve or stay the same?*


#### Optimising our algorithm parameters.



-------------------------------------------------------------------------------

## Troubleshooting
