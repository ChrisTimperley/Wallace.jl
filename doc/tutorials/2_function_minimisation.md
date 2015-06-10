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

### Fitness Schema

### Problem Representation

### Evaluator

### Breeding Operations

-------------------------------------------------------------------------------

## Running the Algorithm 

### Plotting the results using Gadfly.jl
