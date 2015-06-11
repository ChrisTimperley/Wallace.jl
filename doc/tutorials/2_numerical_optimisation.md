# Tutorial 2: Numerical Optimisation using Genetic Algorithms

Building on the previous tutorial, in this tutorial we shall be using simple
Genetic Algorithms once again, this time to minimise a series of
numerical optimisation benchmark functions. In order to determine the minima of these
functions, we make use of the floating point vector representation, used to
represent fixed-length real-valued vectors.

**This tutorial assumes:**

* You have a minimal knowledge of [Julia](http://www.julialang.org).
* You have completed the first tutorial.
* You know how to construct a simple Genetic Algorithm using Wallace.

**By the end of this tutorial, you will be able to:**

* Evolve fixed-length real-valued vectors.
* Write a simple GA to solve multi-modal numerical optimisation problems.

-------------------------------------------------------------------------------

## The Problem

Benchmark | Equation | Minimum | Search Domain  
--------- | -------- | ------- | -------------
Sphere | ![Sphere function](https://upload.wikimedia.org/math/0/7/7/0770a5cfa1d5ad1f6c403315cca90493.png) | ![Sphere function minimum](https://upload.wikimedia.org/math/7/0/a/70a7231688ab8a6746e6096e69f858b3.png) | ![Sphere function domain](https://upload.wikimedia.org/math/6/e/d/6edd4ad0bea50fa9b2f0dbacd62fa911.png)
Rastrigin | ![Rastrigin function](https://upload.wikimedia.org/math/5/8/3/5831f65c6b1d64c2cf83d8eac84e1c3c.png) ![Rastrigin function A term](https://upload.wikimedia.org/math/d/9/7/d97446f1d0af787d9932516e0f4179e9.png) | ![Rastrigin function minimum](https://upload.wikimedia.org/math/7/0/a/70a7231688ab8a6746e6096e69f858b3.png) | ![Rastrigin function domain](https://upload.wikimedia.org/math/8/9/f/89f8f3dc16012a185e5a31ec62c919e5.png)
Rosenbrock | ![Rosenbrock function](https://upload.wikimedia.org/math/8/c/e/8ce1d6b5e80401a6df5e97bb984bb9b7.png) | ![Rosenbrock minimum](https://upload.wikimedia.org/math/a/a/6/aa624d2d2f3478149d2060aa39bd0d70.png) | ![Rosenbrock domain](https://upload.wikimedia.org/math/6/e/d/6edd4ad0bea50fa9b2f0dbacd62fa911.png)

## Basic Setup

For this problem we will be using a near-identical general setup to the one we
used in the previous tutorial, given below.

Component       | Setting                                           |
--------------- | ------------------------------------------------- |
Population      | Simple (single deme)                              |
Breeder         | Simple (i.e. selection, crossover, mutation)      |
Species         | Simple (single representation)                    |
Fitness Schema  | Scalar (float, minimisation)                      |
Representation  | Float vector (length tailored to function)        |

### Fitness Schema

As the objective for each of these benchmarks is to find the global minimum
value for the function within the bounds of the search domain, our fitness
schema should minimise a floating point value, representing the value of the
function for a given set of co-ordinates.

```
fitness<fitness/scalar>:
  of:       Float
  maximise: false
```

### Problem Representation

For each of these benchmark functions we will be optimising vectors of real
numbers. In order to best represent these vectors we'll be using the
floating point vector, which will represent each of the real values as a
fixed-length floating point integer.

Here we can make use of the look-up operator within the Wallace specification
language, `$()`, to create a specification tailored to our problem by allowing
the length of the vector to be specified within the top-level `problem_size`
property of the specification.

```
representation<representation/float_vector>:
  length: $(problem_size)
```

As the scope of our search will be confined within a given search domain for
each of the benchmark problems, we can specify the minimum and maximum value that
any component within the vector may assume using the `min_value` and `max_value`
properties.

Once again, we can use the look-up operator to allow the minimum and maximum
values for all vector components to be specified at the top-level of the
specification, allowing them be changed to suit our particular benchmark more easily.

```
representation<representation/float_vector>:
  length: $(problem_size)
  min:    $(problem_min)
  max:    $(problem_max)
```

### Breeding Operations

### Evaluator

Finally, with our problem representation, breeding operations, and schema
configured, we can provide the evaluator for our problem, responsible for
calculating the fitness values of potential solutions. As mentioned before, the
fitness of our individuals will be given by their function value for the
particular problem we're trying to solve.

To calculate this function value and assign it as the fitness of individuals
within the population we can make use of the same `evaluator/simple`
evaluator that we used in the first tutorial.

```
evaluator<evaluator/simple>:
```

To recap, this evaluator takes only two parameters: `objective`, which
provides a definition for a Julia function capable of computing the fitness
of a given individual, and `threads`, which instructs Wallace how many threads
to split the evaluation workload across.

At this point our algorithm specification becomes specific to the particular
benchmark we're attempting to optimise, as the `objective` of our evaluator
will be different for them all. Below is an example of how the Sphere
benchmark might be calculated using a Julia function.

```
evaluator<evaluator/simple>:
  objective: |
    f = 0.0
    for x in get(i.genome)
      f += x*x
    end
    fitness(scheme, f)
```

As in the first tutorial, we construct and return a fitness object for our
individual using the `fitness()` function in combination with our schema,
provided to the objective function by the `scheme` parameter. **(This is
possibly subject to change).**

-------------------------------------------------------------------------------

## Running the Algorithm 

### Plotting the results using Gadfly.jl
