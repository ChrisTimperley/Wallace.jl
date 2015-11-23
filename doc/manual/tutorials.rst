=========
Tutorials
=========

In this section of the tutorial, we provide a number of fairly basic tutorials,
covering the usage of various algorithms, operators, and representations within
Wallace. All of the tutorials assume that the reader has a basic knowledge of
evolutionary algorithms, and that they have read the Basics section of this
documentation.

Getting Started
===============

* Installing IJulia.
* Installing Pandas and matplotlib.

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

  br.crossover = crossover.one_point(0.5)

Where 0.5 is the crossover rate.

Mutation
~~~~~~~~

Given our use of the bit vector representation, we make use of the most
naturally fitting mutation operator, bit flip mutation, implemented by
``mutation.bit_flip``. Bit-flip mutation works by iterating across a provided
chromosome and applying a bit-flip at each gene according to some probability,
given by the mutation rate.

As with one point crossover, bit flip mutation only accepts a single parameter,
the mutation rate. As such, we can concisely specify this operator via the
following:

::

  br.mutation = mutation.bit_flip(0.05)

Where 0.05 is the per-gene mutation rate, or the probability that the value of
a given gene will be flipped.

Adding an evaluator
-------------------

Next, we will provide our algorithm with an evaluator, responsible for
computing the objective function values for provided candidate solutions. For
this problem, the simple evaluator, ``evaluator.simple`` will suffice. Unlike
other components within Wallace, where the block following the method call is
used to specify its properties, for the simple evaluator, this block is used
to implement the objective function.

The supplied objective function should accept two arguments, the fitness
scheme, and the chromosome for the candidate solution, respectively. Once
an objective function for the candidate has been computed, a partial fitness
value for the individual should be computed from that value and returned. In
order to compute the fitness value, we pass the objective value to the
``assign`` method, preceded by the fitness scheme.

Since the objective is measured by the number of 1s in a provided bit vector,
we can quickly compute the objective value using Julia's ``sum`` function.

Putting together all of the above, we should end up with an evaluator that
looks something like the one below.

::

  alg.evaluator = evaluator.simple() do scheme, genome
    assign(scheme, sum(genome))
  end

If you query the documentation for the simple evaluator, you may notice it
also has two optional keyword parameters. ``threads`` is used to specify the
number of threads that the evaluation should be split across; leave this
for now. The ``stage`` parameter is used to specify the name of which of an
individual's developmental stages should be supplied to the evaluator to
perform the evaluation; where no value is given, this parameter defaults to
using the genotype.

Adding the termination conditions
---------------------------------

We now have a near complete algorithm specification. The only task remaining is
to provide a set of termination conditions, else our algorithm won't terminate
unless the program is forcibly closed by the user.

In order to add a termination condition to our algorithm, we add an named entry
into its ``termination`` dictionary. We implement each of our mutually
inclusive termination conditions using instances of the ``criterion`` type. In
order to find a list of available criteria, perform a look-up using Julia's
help function on the ``criterion`` type.

For this problem, we will simply add a generation limit, which will terminate
the algorithm once a given number of generations have passed (where the
initialisation phase is not counted as a generation). We can do this using
the ``criterion.generations`` criterion, as shown below:

::

  alg.termination["generations"] = criterion.generations(1000)

Where 1000 refers to the generation limit.

Running the algorithm and analysing the results
-----------------------------------------------

Having followed the steps above, you should now have a complete algorithm
specification that we can use to solve our problem. Your code should look
something similar to that given below:

::

  using Wallace

  def = algorithm.genetic() do alg
    alg.population = population.simple() do pop
      pop.size = 100

      pop.species = species.simple() do sp
        sp.fitness = fitness.scalar(Int)
        sp.representation = representation.bit_vector(100)
      end

      pop.breeder = breeder.simple() do br
        br.selection = selection.tournament(2)
        br.mutation = mutation.bit_flip(0.05)
        br.crossover = crossover.one_point(0.5)
      end
    end

    alg.evaluator = evaluator.simple() do scheme, genome
      assign(scheme, sum(genome))
    end

    alg.termination["generations"] = criterion.generations(1000)
  end

  executable = compose!(alg)
  run!(executable)

Give the code a run a few times, using ``run!``, and see what kind of results
you can attain using the parameters settings we provided above. You might be
disappointed by the end-result of the algorithm, but don't worry, we've given
you sub-optimal parameters on purpose.

**Can you figure out a better set of parameters, which converge on the global
optimum faster?** Once you've managed that, you might want to try experimenting
with other compatible selection and crossover methods, or maybe increasing the
difficult of the problem.

Performing search diagnostics with logging and visualisation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Currently integrating EvoAnalyser.py into Wallace.

Adding parallel evaluation and breeding
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

So far we have been running (quite intensively) the algorithm on a single
thread, but the rest of our available hyper-threads and cores are left doing
nothing. In order to maximise our CPU usage, and to maximise the performance of
our algorithm, we can use a multi-threaded configuration of our breeder and
evaluation to split their respective processes across multiple threads.

Enabling multi-threading within our algorithm is as simply as specifying the
number of threads that we wish to split the problem across in our evaluator
and breeder definitions. In both cases, the number of threads is specified by
the ``threads`` parameter, which is accepted as a keyword by the
``evaluator.simple`` evaluator.

Try scaling up the difficulty of the problem by increasing the size of the bit
vector, then compare the performance of the single-threaded and multi-threaded
configurations of the algorithm using Julia's ``@time`` macro, as shown below.

::

  single = algorithm.genetic() do alg
    ...
  end

  multi = algorithm.genetic() do alg
    ...
  end

  exec_s = compose!(single)
  exec_m = compose!(multi)

  run!(exec_s)
  run!(exec_m)

  @time run!(exec_s)
  @time run!(exec_m)

Note, that due to the nature of Julia's JIT (just-in-time) compiler, the
algorithms run faster after they have been run at least once.
**This difference may be smaller in the future, where each composed algorithm
is immediately pre-compiled, prior to being used by ``run!``.**

You may also find that performance is slightly improved by running the above
code within a function, rather than letting the algorithms become global
variables. A few (excellent) tips on improving the performance of general
Julia code can be found at: http://docs.julialang.org/en/latest/manual/performance-tips/.

Floating Point Vectors and Numerical Optimisation
=================================================

Building on the previous tutorial, in this tutorial we shall be using simple
Genetic Algorithms once again, this time to minimise a series of numerical
optimisation benchmark functions. In order to determine the minima of these
functions, we make use of the floating point vector representation, used to
represent fixed-length real-valued vectors.

Problem
-------

..  |sphere| image:: https://upload.wikimedia.org/math/0/7/7/0770a5cfa1d5ad1f6c403315cca90493.png
..  |rastrigin| image:: https://upload.wikimedia.org/math/5/8/3/5831f65c6b1d64c2cf83d8eac84e1c3c.png
..  |rosenbrock| image:: https://upload.wikimedia.org/math/8/c/e/8ce1d6b5e80401a6df5e97bb984bb9b7.png

..  |min_sphere| image:: https://upload.wikimedia.org/math/7/0/a/70a7231688ab8a6746e6096e69f858b3.png
..  |min_rastrigin| image:: https://upload.wikimedia.org/math/7/0/a/70a7231688ab8a6746e6096e69f858b3.png
..  |min_rosenbrock| image::  https://upload.wikimedia.org/math/a/a/6/aa624d2d2f3478149d2060aa39bd0d70.png

..  |dom_sphere| image:: https://upload.wikimedia.org/math/6/e/d/6edd4ad0bea50fa9b2f0dbacd62fa911.png
..  |dom_rastrigin| image:: https://upload.wikimedia.org/math/8/9/f/89f8f3dc16012a185e5a31ec62c919e5.png
..  |dom_rosenbrock| image:: https://upload.wikimedia.org/math/6/e/d/6edd4ad0bea50fa9b2f0dbacd62fa911.png

==========================  =============  ================   ==================
Benchmark                   Equation       Minimum            Search Domain
==========================  =============  ================   ==================
Sphere                      |sphere|       |min_sphere|       |dom_sphere|
Rastrigin :math:`A = 10`    |rastrigin|    |min_rastrigin|    |dom_rastrigin|
Rosenbrock                  |rosenbrock|   |min_rosenbrock|   |dom_rosenbrock|
==========================  =============  ================   ==================

Skeleton
--------

Rather than declaring our algorithm at the top-level in this tutorial, we will
instead write a function which returns a version of our algorithm, tailored to
the specifics of one of the benchmarks above. The skeleton of our function
should look something like the one given below.

::

  function tutorial_two(size::Int, min::Float, max::Float)
    definition = algorithm.simple_ga() do
      ...
    end
    compose!(definition)
  end

Where `size::Int` is used to specify the number of dimensions, `min::Float` is
used to specify the minimum value that a dimension may take (which is assumed to
be equal for all dimensions), and similarly, `max::Float` specifies the maximum
value that a dimension may assume.

Setup
-----

For this problem we will be using a near-identical general setup to the one we
used in the previous tutorial, given below.

================  ==================================================
Component         Setting                                           
================  ==================================================
Population        Simple (single deme)                              
Breeder           Simple (i.e. selection, crossover, mutation)      
Species           Simple (single representation)                    
Fitness Schema    Scalar (float, minimisation)                      
Representation    Float vector (length tailored to function)        
================  ==================================================

Fitness Schema
~~~~~~~~~~~~~~

As the objective for each of these benchmarks is to find the global minimum
value for the function within the bounds of the search domain, our fitness
schema should minimise a floating point value, representing the value of the
function for a given set of co-ordinates.

::
  
  sp.fitness = fitness.scalar() do f
    f.maximise = False
  end

  sp.fitness = fitness.scalar(False)

Representation
~~~~~~~~~~~~~~

For each of these benchmark functions we will be optimising vectors of real
numbers. In order to best represent these vectors we'll be using the
floating point vector, which will represent each of the real values as a
fixed-length floating point integer.

Making use of the arguments supplied to our algorithm building function, we can
build a problem-specific representation using the code below. Notice that the
DSL is a super-set of Julia, and can thus be used in all the ways it otherwise
would be.

::

  sp.representation = representation.float_vector() do fv
    fv.length = size
    fv.min = min
    fv.max = max
  end

Order-Based Genomes and the Travelling Salesman Problem
=======================================================

Koza Tree Genetic Programming and Symbolic Regression
=====================================================
