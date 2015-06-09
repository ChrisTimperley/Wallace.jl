# Symbolic Regression

Problem description.

**This tutorial assumes:**

* A basic knowledge of [Julia](http://julialang.org/).
* You know how to create and run a basic genetic algorithm within Wallace.

**By the end of this tutorial, you will be able to:**

* Perform loosely-typed genetic programming within Wallace.

--------------------------------------------------------------------------------

## The Problem


## Basic Setup
For this problem, we shall be using a standard evolutionary algorithm, with the
components listed below:

| Component           | Setting                                           |
| ------------------- | ------------------------------------------------- |
| Population          | Simple (single deme)                              |
| Representation      | Loosely-Typed Koza Tree                           |
| Breeder             | Simple Breeder                                    |
| Fitness Scheme      | Koza Fitness                                      |

## Solution Representation

Loosely-typed Koza Trees.

```
_my_species<species/simple>:
  fitness<koza>: { minimise: true }
  representation<representation/koza_tree>:
    min_depth: 1
    max_depth: 18
    inputs: ["x::Float"]
    terminals: ["x::Float"]
    non_terminals:
      - "add(x::Float, y::Float)::Float = x + y"
      - "sub(x::Float, y::Float)::Float = x - y"
      - "mul(x::Float, y::Float)::Float = x * y"
```

### Tree Builders

### Ephemeral Random Constants

## Setting up the Breeder

```
breeder<breeder/simple>:
  selection<selection/tournament>: { size: 5 }
  crossover<crossover/subtree>: { rate: 0.9 }
  mutation<mutation/subtree>: { rate: 0.01 }
```


## Running the Algorithm

After having followed all the preceding steps, you should have an algorithm
that roughly looks similar to the one given below:

```
type: algorithm/simple_evolutionary_algorithm
```

## Dealing with Bloat
