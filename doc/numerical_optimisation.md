---
layout: page
title: Numerical Optimisation
permalink: /tutorials/numerical_optimisation/
---

## Basic Setup

Component       | Setting                                           |
--------------- | ------------------------------------------------- |
Population      | Simple (single deme)                              |
Breeder         | Simple (i.e. selection, crossover, mutation)      |
Species         | Simple (single representation)                    |
Fitness Schema  | Scalar (float, minimisation)                      |
Representation  | Float vector (length tailored to function)        |

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

<pre class="wallace">
mutation&lt;mutation/gaussian&gt;:
  rate: 0.01
  mean: 0.0
  std:  1.0
</pre>

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
