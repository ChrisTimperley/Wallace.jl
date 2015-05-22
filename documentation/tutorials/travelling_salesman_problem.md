# Solving the Travelling Salesman Problem using Genetic Algorithms

**Author:** [Chris Timperley](http://www.christimperley.co.uk),
**Difficulty:** Beginner,
**Duration:** 15-30 minutes.

In this tutorial, we shall use Wallace to implement a generic algorithm to
solve the travelling salesman problem, in which we wish to find the shortest
possible route through a given set of cities, which visits all cities exactly once
and return to the city at which the tour was started. The TSP is a prime example
of an NP-hard, or more specifically, NP-complete, problem that can be
effectively tackled using techniques such as genetic algorithms and ant colony
optimisation.

**This tutorial assumes:**

* A minimal knowledge of [Julia](http://julialang.org/).
* You know how to create and run a basic genetic algorithm within Wallace.
* You know how the advanced breeder works within Wallace.

**By the end of this tutorial, you will be able to:**

* Use Wallace to implement genetic algorithms capable of solving
  permutation-based problems, such as the travelling salesman problem.

--------------------------------------------------------------------------------

## Basic setup

```

```


## Running the algorithm

Having followed the steps above, you should be left with a specification looking
somewhat similar to the one given below:

```
type: algorithm/simple_evolutionary_algorithm

evaluator<evaluator/simple>:
  objective: |
    SimpleFitness{Int}(true, sum(get(i.bits)))

replacement<replacement/generational>: { elitism: 0 }

termination:
  iterations<criterion/iterations>: { limit: 1000 }

_my_species:
  stages:
    bits:
      representation<representation/bit_vector>: { length: 100 }

_my_breeder<breeder/fast>:
  sources:
    s<selection>:
      operator<selection/tournament>: { size: 2 }
    x<variation>:
      operator<crossover/one_point>: { rate: 1.0 }
      source: s
      stage:  bits
    m<variation>:
      operator<mutation/bit_flip>: { rate: 0.1 }
      source: x
      stage:  bits

population:
  demes:
    - capacity: 100
      breeder:  $(_my_breeder)
      species:  $(_my_species)
```

