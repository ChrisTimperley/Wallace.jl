======
Basics
======

In this section, we cover the basic concepts employed within Wallace, focusing
on those relating to evolutionary algorithms, and less on any other concepts
concerned with other meta-heuristics supported within the framework.

For now, this section assumes that the reader has at least a basic knowledge
of the structure and concepts of evolutionary algorithms.

-------------------------------------------------------------------------------

Algorithm
=========

The domain-specific language within Wallace is entirely tailored around the
specification and subsequent fine-tuning of algorithms for particular problem
instances. Users provide a specification of their problem to a particular
algorithm constructor, chosen according to the search algorithm they wish to
use to solve the problem, which is then composed into a heavily optimised
``Algorithm`` instance via the ``compose!`` method, before being ready for
executed using the ``run!`` method.

Wallace supports a number of different meta-heuristic algorithms, ranging from
random walks and hill climbing, to ant colony optimisation and evolutionary
algorithms. For the remainder of this section however, we shall focus our
discussion on the implementation of evolutionary algorithms within Wallace.
More details about the other types of algorithms supported within Wallace
may be found in the reference section of the documentation.

Population
==========

Abstractly, the population of the algorithm is used to hold the individuals
which are presently alive within the current generation, as well as the
offspring born within that generation. Each individual within the population is
used to represent a candidate solution to the problem being solved.

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

The full power of the deme model can be utilised with the
``population.complex`` model, which allows the user to add an arbitary number
of heterogeneous demes to the population. This ability can be exploited to
spread the search across multiple physical machines, or to allow the search to
test different problem representation and search parameters at the same time.

Island Model
------------

Where the complex population model is employed, one may also choose to make use
of an island model population.

In island model populations, each deme is conceptualised as a island within
some imaginary archipelago, where all the individuals in that deme are confined
to that island.

* After a certain number of generations, known as the *migration interval*,
  a pre-determined number, or fraction of individuals from each island may migrate
  from their island to a neighbouring island.
* The islands that an individual may migrate to from their current island is
  determined by the *migration topology*, which describes the connections
  between islands. By default, a fully connected topology is used, where every
  island can be reached by any other.
* The individuals selected to leave an island, and those chosen to be removed
  from an island to make room for them, are both decided according to a
  pre-determined *migration policy*.

An example of a simple island model population for the one max problem is shown
below:

**EXAMPLE CODE**

Species
==============

Fitness
=======

Breeding
========
