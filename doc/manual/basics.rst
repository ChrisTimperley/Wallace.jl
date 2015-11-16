======
Basics
======

Meta.

-------------------------------------------------------------------------------

Algorithm
=========

What is an algorithm?

For the rest of this section, we shall focus on the basics of evolutionary
algorithms within Wallace, rather than covering its other meta-heuristic
algorithms in depth.

Population
==========

Abstractly, the population of the algorithm is used to hold the individuals
which are presently alive within the current generation, as well as their
offspring at that generation.

Like many other evolutionary computation frameworks, Wallace models the
population of an algorithm as a set of demes, or sub-populations, each
containing a (nearly) isolated collection of individuals. Within each
deme, all individuals belong to the same species, but within the population,
each deme may elect to use a different species.

..  class:: center

  ..  image:: ../_diagrams/population.png

Simple Populations
------------------

For simple problems, one can use the ``population.simple`` model to quickly specify
a single deme population, which effectively hides the inner details of the deme
model from the user.

Complex Populations
-------------------

Island Model
------------

Species
==============

Fitness
=======

Breeding
========
