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
* You know how the linear breeder works within Wallace.

**By the end of this tutorial, you will be able to:**

* Use Wallace to implement genetic algorithms capable of solving
  permutation-based problems, such as the travelling salesman problem.

--------------------------------------------------------------------------------

## Basic setup

```
type: algorithm/evolutionary_algorithm

evaluator<evaluator/tsp>:
  cities: berlin52.tsp

replacement<replacement/generational>: {}

termination:
  evaluations<criterion/evaluations>: { limit: 100000 }

_my_species<species/simple>:
  representation<representation/permutation>:
    alphabet: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25
      26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
      50, 51, 52]

_my_breeder<breeder/linear>:
  sources:
    - operator<selection/tournament>: { size: 4 }
    - operator<crossover/pmx>: {}
    - operator<mutation/2_opt>: {}

population<population/simple>:
  size:     100
  breeder:  $(_my_breeder)
  species:  $(_my_species)
```

## Running the algorithm

