---
layout: page
title: Numerical Optimisation
permalink: /tutorials/numerical_optimisation/
---

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
