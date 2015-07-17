---
layout: page
title: Symbolic Regression
permalink: /tutorials/symbolic/
---

# Tutorial 4: Symbolic Regression via Genetic Programming

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

<pre class="wallace">
_my_species&lt;species/simple&gt;:
  fitness&lt;koza&gt;: { minimise: true }
  representation&lt;representation/koza_tree&gt;:
    min_depth: 1
    max_depth: 18
    inputs: ["x::Float"]
    terminals: ["x::Float"]
    non_terminals:
      - "add(x::Float, y::Float)::Float = x + y"
      - "sub(x::Float, y::Float)::Float = x - y"
      - "mul(x::Float, y::Float)::Float = x * y"
</pre>

### Tree Builders

* Ramped Half-and-Half
* Full
* Grow

### Ephemeral Random Constants

## Setting up the Breeder

<pre class="wallace">
breeder&lt;breeder/simple&gt;:
  selection&lt;selection/tournament&gt;: { size: 5 }
  crossover&lt;crossover/subtree&gt;: { rate: 0.9 }
  mutation&lt;mutation/subtree&gt;: { rate: 0.01 }
</pre>

## Running the Algorithm

After having followed all the preceding steps, you should have an algorithm
that roughly looks similar to the one given below:

<pre class="wallace">
type: algorithm/simple_evolutionary_algorithm

evaluator&lt;evaluator/regression&gt;:
  file: points.csv

replacement&lt;replacement/generational&gt;: { elitism: 0 }

termination:
  iterations&lt;criterion/iterations&gt;: { limit: 1000 }

_my_species<species/simple>:
  fitness<fitness/simple>: { of: Float, maximise: false }
  representation&lt;representation/koza_tree&gt;:
    min_depth: 1
    max_depth: 18
    inputs: ["x::Float64"]
    terminals: ["x::Float64"]
    non_terminals:
      - "add(x::Float64, y::Float64)::Float64 = x + y"
      - "sub(x::Float64, y::Float64)::Float64 = x - y"
      - "mul(x::Float64, y::Float64)::Float64 = x * y"
  
_my_breeder&lt;breeder/fast&gt;:
  selection&lt;selection/tournament&gt;: { size: 5 }
  crossover&lt;crossover/subtree&gt;: { rate: 0.9 }
  mutation&lt;mutation/subtree&gt;: { rate: 0.01 }

population:
  demes:
    - capacity: 100
      species:  $(_my_species)
      breeder:  $(_my_breeder)
</pre>

## Dealing with Bloat
