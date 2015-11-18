=========
Tutorials
=========

Assumptions. Should have read the Basics section.

Simple Genetic Algorithms and Max Ones
======================================

In this tutorial, we will be using Wallace to implement a simple Genetic
Algorithm to solve the benchmark Max Ones optimisation problem, in which the
object is to maximise the number of ones in a fixed-length binary string.
This problem is trivial for humans, of course, but proves to be a little
trickier for “blind” evolutionary algorithms.

Getting started
---------------

Once you have Wallace installed on your machine, create a new Julia file for
this tutorial, named ``tut1.jl``, or whatever you wish. At the top of this
file, don't forget to make Wallace available via ``using Wallace``.

For the rest of this tutorial, and all the other tutorials, you will now be
writing to this (or another) Julia script file, which can be executed from
the command line by simply calling:

::

  $ julia tut1.jl

You may find it useful to keep the Julia REPL in another tab, in order to
allow you to quickly navigate the Wallace documentation via Julia's help
command. Once in the Julia REPL, if you type ``?`` into the command prompt,
the REPL will be switched into help mode. When in this mode, you may enter
the name of a particular component, method, type, or Julia function for which
you wish to view the documentation.

::

  help> mutation.bit_flip

    Performs bit-flip mutation on a fixed or variable length chromosome of binary
    digits, by flipping 1s to 0s and 0s to 1s at each point within the chromosome
    with a given probability, equal to the mutation rate.

    **Parameters:**

    * `stage::AbstractString`, the name of the developmental stage that this
      operator should be applied to. Defaults to the genotype if no stage is
      specified.
    * `rate::Float`, the probability of a bit flip at any given index.
      Defaults to 0.01 if no rate is provided.

**Tip: Don't forget, in order to view the documentation for Wallace, you must
first make Wallace available to Julia by calling ``using Wallace``.**

Creating a skeleton for our algorithm specification
---------------------------------------------------

All algorithm instances within Wallace are first outlined by providing details
of the exact configuration to the appropriate algorithm constructor. In this
case, as we wish to a Simple GA to solve the problem, we make use of the
``algorithm.simple_genetic`` constructor.

Unlike the constructor for ``algorithm.SimpleGenetic``, the underlying type
used to implement the simple GA, ``algorithm.simple_genetic`` is used to
produce a specification of an algorithm, which is then synthesised into an
executable instance using the ``compose!`` method.

Below is a skeleton for a simple GA definition. The block following the
closing parentheses is used to implement the domain-specific language of
Wallace, allowing a provided algorithm specification, ``alg``, to be
manipulated and completed.

::
  
  alg = algorithm.simple_genetic() do alg

  end

Once we've finished filling out the skeleton above, which we will proceed
to do over the next few parts of this tutorial, we can compose the algorithm
and run it via the following code:

::

  executable = compose!(alg)
  run!(executable)

**Performance tip:** Wrap inside function; don't use globals.

Specifying the components of our algorithm
------------------------------------------

Now we have our skeleton in place, let's proceed to specify each of the
components of our algorithm. Before we can do this, however, we need to
know what the components of our particular algorithm are. In order to
find out this information, we can make use of the help function within
the Julia REPL (or Juno) to view the information about our algorithm:

::

  julia> using Wallace
  help> algorithm.simple_genetic

    DESCRIPTION OF THE SIMPLE GENETIC ALGORITHM

    Properties:

    * evaluator, the evaluator used to compute objective function values for
      the candidate solutions.
    * replacement, the replacement scheme used to determine the membership of a
      deme at each generation, from its existing members and their offspring.
      Defaults to ``replacement.generational`` if none is specified.
    * termination, a dictionary of termination conditions for this algorithm,
      specified as ``criterion`` instances, indexed by their names.
    * population, a specification of the population used by this algorithm,
      detailing its size, demes, species, etc.
    * loggers, a list of loggers that should be attached to this algorithm to log
      various data. Provided as ``logger`` specifications.

Armed with this information, we can now delve deeper into the domain specific
language, querying the help function about the types used by each of the
properties of our algorithm, such as ``population``, ``replacement``, ``logger``,
and so on.

Setting up the population
-------------------------

To begin with, let's specify the population used by our algorithm. For this
problem, a simple population, with a single deme and species, specified using
``population.simple``, will suffice. Using the help function, we can find the
necessary properties to set up our population.

After specifying the size of our population, the skeleton for our population
specification should look similar to the one given below (where the ellipsis
will be replaced by species and breeder specifications later on).

::

  alg.population = population.simple() do pop
    pop.size = 100
    pop.species = ...
    pop.breeder = ...
  end

Specifying the species
----------------------

In order to complete our population specification, let us next move onto
specifying the species to which all of its members belong. Again, for the
purposes of this problem, where the search only requires one form of
representation, namely the bit-string, the simple species model,
``species.simple``, will suffice.

After performing a help query to learn the properties of ``species.simple``,
we will learn that there are only two properties that need to be provided;
``fitness``, specifying the fitness scheme used to transform objective function
values returned by the evaluator into fitness values, and ``representation``,
used to describe the representation used to model candidate solutions to the
problem.

::
  
  pop.species = species.simple() do sp
    sp.fitness = ...
    sp.representation = ...
  end

Designating a fitness scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

First, let us outline the fitness scheme that will be used. You may notice from
the documentation for ``species.simple``, that if no fitness scheme is supplied,
the species will default to using a scalar fitness scheme, ``fitness.scalar``,
where the fitness function returns floating points that are to be maximised.

For our problem, however, we really want fitness values to be represented by
integers, rather than performing an unnecessary conversion to a floating point
number. A scalar fitness shall still suffice though, so we can provide our
species with the following fitness scheme definition:

::

  sp.fitness = fitness.scalar() do f
    f.of = Int
    f.maximise = True
  end

Alternatively, as shown in the documentation, we may also elect to specify our
``fitness.scalar`` in a number of different ways. We can achieve the same
effect in fewer lines of code using the code below, but in the process we
possibly trade-off a smaller amount of readability for those less acquainted
with Wallace.

::
  
  sp.fitness = fitness.scalar(Int)

Detailing the problem representation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With a fitness scheme now in place, we need only provide a specification of the
representation used by candidate solutions within the population. For our
particular problem we want to use the bit vector representation, implemented
by ``representation.bit_vector``, where solutions take the form of a
fixed-length vector of boolean values (representing bits).

Reading the documentation for the ``representation.bit_vector``, we learn that
this representation has only a single parameter, namely its length, given
by the ``length`` property.

For this tutorial, let us create a bit vector of length 100, to begin with. We
may do so using either of the definitions given below.

::

  sp.representation = representation.bit_vector() do rep
    rep.length = 100
  end

  sp.representation = representation.bit_vector(100)

Specifying the breeding operations
----------------------------------

Now we have a complete species specification, the only thing remaining in our
population specification is to provide a description of the breeding process
it uses.

Again, we will make use of Wallace's simplest breeder, ``breeder.simple``,
which implements breeding as a process of selection, followed by crossover,
and finishing with mutation, with each stage performed by a single operator.
Reading the documentation for ``breeder.simple``, we end up with the following
skeleton specification:

::

  pop.breeder = breeder.simple() do br
    br.selection = ...
    br.crossover = ...
    br.mutation = ...
  end

Selection
~~~~~~~~~

For the purposes of this tutorial, we will use the simple, but rather effective
method of tournament selection as our method of choice, implemented by
``selection.tournament``. After reading the documentation, we can quickly
specify a tournament selection via the following:

::

  br.selection = selection.tournament(2)

Where 2 is the size of the tournament.

Crossover
~~~~~~~~~

As our crossover method, we will use a simple one-point crossover, which accepts
two parent genomes are supplied to the operator, following which a random point
common to the two genomes is selected, each genome is split into two parts
about this point, and finally two new genomes are formed by combining the first
and second parts of opposite parents. This method of crossover is implemented
by the ``crossover.one_point`` operator.

As the only parameter for one point crossover is the crossover rate, which
determines the probability that a given pair of chromosomes will be subject to
the crossover process, rather than being left alone, we can specify our
operator using the following syntax:

::

  br.crossover = crossover.one_point(0.7)

  Where 0.7 is the crossover rate.
  

Mutation
~~~~~~~~

Adding the termination conditions
---------------------------------

Running the algorithm and analysing the results
-----------------------------------------------

Solving Numerical Optimisation problems using GAs
=================================================

Order-Based Genomes and the Travelling Salesman Problem
=======================================================

Koza Tree Genetic Programming and Symbolic Regression
=====================================================
