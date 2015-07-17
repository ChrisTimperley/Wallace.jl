---
layout: page
title: Numerical Optimisation
permalink: /tutorials/numerical_optimisation/
---

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

<pre class="wallace">
fitness&lt;fitness/scalar&gt;:
  of:       Float
  maximise: false
</pre>

### Problem Representation

For each of these benchmark functions we will be optimising vectors of real
numbers. In order to best represent these vectors we'll be using the
floating point vector, which will represent each of the real values as a
fixed-length floating point integer.

Here we can make use of the look-up operator within the Wallace specification
language, `$()`, to create a specification tailored to our problem by allowing
the length of the vector to be specified within the top-level `problem_size`
property of the specification.

<pre class="wallace">
representation&lt;representation/float_vector&gt;:
  length: $(problem_size)
</pre>

As the scope of our search will be confined within a given search domain for
each of the benchmark problems, we can specify the minimum and maximum value that
any component within the vector may assume using the `min_value` and `max_value`
properties.

Once again, we can use the look-up operator to allow the minimum and maximum
values for all vector components to be specified at the top-level of the
specification, allowing them be changed to suit our particular benchmark more easily.

<pre class="wallace">
representation&lt;representation/float_vector&gt;:
  length: $(problem_size)
  min:    $(problem_min)
  max:    $(problem_max)
</pre>

### Breeding Operations

As our problem is a relatively simple one, we will once again use the
`breeder/simple` breeder to generate the offspring for the population at each
generation. Feel free to investigate and experiment with different selection,
mutation and crossover operators, but for the rest of the tutorial we will be
using the setup given below.

<pre class="wallace">
_my_breeder&lt;breeder/simple&gt;:
  selection&lt;selection/tournament&gt;: { size: 4 }
  crossover&lt;selection/two_point&gt;: { rate: 0.7 }
  mutation&lt;mutation/gaussian&gt;: { rate: 0.01, mean: 0.0, std: 1.0 }
</pre>

To perform parent selection, we will be using the simple but effective method
of tournament selection once again, wherein a pre-determined number of parental
candidates are randomly selected from the population and put into a *tournament*
to determine the best amongst them, which becomes selected as a parent. You could
also try experimenting with other methods such as *roulette wheel selection* and
*stochastic universal sampling*.

<pre class="wallace">
selection&lt;selection/tournament&gt;: { size: 4 }
</pre>

For our method of crossing over parents to produce proto-offspring, we shall be
using the `two point crossover` method. This method takes two vectors of equal
length, and randomly selects two points, or loci, along the genome, before
exchanging all genes between those two points across the two parents, generating
two children. For this operator, the `rate` property specifies the probability that
a crossover will occur during a call; if this event occurs, then the two parents
are passed to the mutation operator unaltered.

<pre class="wallace">
crossover&lt;crossover/two_point&gt;: { rate: 0.7 }
</pre>

Once again, there are a multitude of different crossover operators that could
be effectively applied to our given problem, and we encourage you to experiment
with as many as possible. To begin with, you could look into using one-point crossover
again, as used in the previous tutorial, or you could use uniform crossover, which
creates an offspring from two given parents on a locus-by-locus basis, randomly choosing
whose gene to include at a given locus, or you could try something different altogether.

Finally, as our mutation operator, we're using *gaussian mutation*, which runs along a
genome, and with a given probability, perturbs a gene by adding noise generated from a
predefined normal distribution. Here we can alter the probability that a mutation event
will occur at a given gene, via the `rate` property, or we can specify the parameters of
our normal distribution using the `mean` and `std` properties.

<span class="wallace">
mutation&lt;mutation/gaussian&gt;:
  rate: 0.01
  mean: 0.0
  std:  1.0
</span>

Alternatively, we could use *uniform mutation* to sample a new floating point value
within the search domain at a given locus, or we could implement our own
*noisy mutation* operator, which could perturb genes using noise sampled from
alternative probability distributions, such as the Poisson or Gamma distributions.

### Evaluator

Finally, with our problem representation, breeding operations, and schema
configured, we can provide the evaluator for our problem, responsible for
calculating the fitness values of potential solutions. As mentioned before, the
fitness of our individuals will be given by their function value for the
particular problem we're trying to solve.

To calculate this function value and assign it as the fitness of individuals
within the population we can make use of the same `evaluator/simple`
evaluator that we used in the first tutorial.

<pre class="wallace">
evaluator&lt;evaluator/simple&gt;:
</pre>

To recap, this evaluator takes only two parameters: `objective`, which
provides a definition for a Julia function capable of computing the fitness
of a given individual, and `threads`, which instructs Wallace how many threads
to split the evaluation workload across.

At this point our algorithm specification becomes specific to the particular
benchmark we're attempting to optimise, as the `objective` of our evaluator
will be different for them all. Below is an example of how the Sphere
benchmark might be calculated using a Julia function.

<pre class="wallace">
evaluator&lt;evaluator/simple&gt;:
  objective: |
    f = 0.0
    for x in get(i.genome)
      f += x*x
    end
    fitness(scheme, f)
</pre>

As in the first tutorial, we construct and return a fitness object for our
individual using the `fitness()` function in combination with our schema,
provided to the objective function by the `scheme` parameter. **(This is
possibly subject to change).**

-------------------------------------------------------------------------------

## Running the Algorithm

After following the steps above, you should end up with an algorithm that looks
similar to the one given below, except tailored to the numerical function you
wish to optimise.

<pre class="wallace">
type: algorithm/evolutionary_algorithm

# Sphere function (n = 10)
problem_size: 10
problem_min:  0.0
problem_max:  1.0

evaluator&lt;evaluator/simple&gt;:
  objective: |
    f = 0.0
    for x in get(i.genome)
      f += x*x
    end
    fitness(scheme, f)

termination:
  evaluations&lt;criterion/evaluations&gt;: { limit: 10000 }

_my_species&lt;species/simple&gt;:
  fitness&lt;fitness/scalar&gt;: { of: Float, maximise: false }
  representation&lt;representation/float_vector&gt;:
    length: $(problem_size)
    min:    $(problem_min)
    max:    $(problem_max)

_my_breeder&lt;breeder/simple&gt;:
  selection&lt;selection/tournament&gt;: { size: 4 }
  crossover&lt;crossover/two_point&gt;: { rate: 0.7 }
  mutation&lt;mutation/gaussian&gt;: { rate: 0.01, mean: 0.0, std: 1.0 }

population&lt;population/simple&gt;:
  size:     30
  breeder:  $(_my_breeder)
  species:  $(_my_species)
</pre>

Starting with the Sphere problem, try running your algorithm on each of the
benchmarks using a fixed number of evaluations, and attempt to determine an
optimal set of operators and parameters common to all of them.

### Statistics and visualisation

### Plotting the results using Gadfly.jl
