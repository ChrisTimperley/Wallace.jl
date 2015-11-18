=========
Reference
=========

-------------------------------------------------------------------------------

Algorithm
==========

Genetic Algorithm
-----------------

Simple Genetic Algorithm
------------------------

Evolution Strategy
------------------

Simulated Annealing
-------------------

Hill Climbing
-------------

Random Walk
-----------

-------------------------------------------------------------------------------

Representation
==============

Int Vector (``representation.int_vector``)
------------------------------------------

Float Vector (``representation.float_vector``)
----------------------------------------------

Bit Vector (``representation.bit_vector``)
------------------------------------------

Koza Tree (``koza.tree``)
-------------------------

-------------------------------------------------------------------------------

Fitness
=======

Scalar (``fitness.scalar``)
---------------------------

Aggregate (``fitness.aggregate``)
---------------------------------

Lexicographic (``fitness.lexicographic``)
-----------------------------------------

Belegundu (``fitness.belegundu``)
---------------------------------

Goldberg (``fitness.goldberg``)
-------------------------------

MOGA (``fitness.moga``)
-----------------------

Shared (``fitness.shared``)
---------------------------

-------------------------------------------------------------------------------

Crossover
=========

One Point Crossover (``crossover.one_point``)
---------------------------------------------

Subtree Crossover (``koza.subtree_crossover``)
----------------------------------------------

-------------------------------------------------------------------------------

Mutation
========

Bit-Flip Mutation (``mutation.bit_flip``)
-----------------------------------------

Performs bit-flip mutation on a fixed or variable length chromosome of binary
digits, by flipping 1s to 0s and 0s to 1s at each point within the chromosome
with a given probability, equal to the mutation rate.

**Parameters:**

* `stage::AbstractString`, the name of the developmental stage that this
  operator should be applied to.
  Defaults to the genotype if no stage is specified.
* `rate::Float`, the probability of a bit flip at any given index.
  Defaults to 0.01 if no rate is provided.

-------------------------------------------------------------------------------

Replacement
===========

-------------------------------------------------------------------------------
