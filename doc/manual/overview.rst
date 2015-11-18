========
Overview
========

This chapter provides a high-level overview of Wallace.jl, installation
instructions, information on the different ways to interact with Wallace,
and an example algorithm for solving the Max Ones problem.

-------------------------------------------------------------------------------

Philosophy
==========

Installation
============

The latest stable version of Wallace can be installed via a simple one line
command from within the Julia REPL, given below:

::

  Pkg.add("Wallace")

Alternatively, if you wish to install the bleeding-edge version of Wallace
from the master GitHub branch, you may do so by executing the following
from within the REPL instead:

::

  Pkg.clone("https://github.com/ChrisTimperley/Wallace.jl")

If Wallace is already installed on your system, but you believe it to be out
of date, you may execute the following command via the REPL:

::

  Pkg.update("Wallace")

For information on installing the latest version of Julia, visit the Downloads
page of the Julia website, at: http://julialang.org/downloads/

-------------------------------------------------------------------------------

Using Wallace
=============

There are a number of different ways in which you may wish to interact with
Wallace, several of which are described below:

Julia REPL (Read-Eval-Print-Loop)
---------------------------------

The simplest way to started with Wallace is through Julia's built-in
REPL, which can be accessed by simply typing ``julia`` into the terminal
(once Julia has been installed). Once the REPL has been loaded, one may
use the ``using Wallace`` statement to import the Wallace environment
into the workspace, allowing them to interact with Wallace.

::

    shell> julia
    ...
    ...

    julia> using Wallace

Once inside the REPL, you may make use of Julia's help function, invoked by
typing ``?`` into the prompt, followed by the name of a particular
representation, operator, algorithm, or other entity within Wallace (or Julia)
that you wish to learn more about. An example use of the help function is shown
below:

::

  julia> using Wallace
  help?> mutation.bit_flip
    Performs bit-flip mutation on a fixed or variable length chromosome of binary digits, by flipping 1s to 0s and 0s to 1s at each point
    within the chromosome with a given probability, equal to the mutation rate.

    Parameters:

      • stage::AbstractString, the name of the developmental stage that this operator should be applied to.
        Defaults to the genotype if no stage is specified.
      • rate::Float, the probability of a bit flip at any given index. Defaults to 0.01 if no rate is provided.

Script Execution
----------------

Alternatively you can treat your Wallace algorithms as you would any other
Julia code, and write a standard Julia script to execute them. In order to
access the functionality provided by Wallace, you must import the Wallace
package.

::

  shell> julia my_script.jl

IJulia Graphical Notebook
-------------------------

Another way to interact with Wallace is through IJulia, a powerful graphical
web-based notebook front-end for Julia. More details about IJulia, including
how it should be installed, can be found at: https://github.com/JuliaLang/IJulia.jl.

Once IJulia has been installed, you may start a new notebook, using Wallace,
by following the commands below:

::

    julia> using IJulia
    julia> notebook()

    ijulia> using Wallace

-------------------------------------------------------------------------------

Example
=======

Below is the source code for the Max Ones benchmark problem provided in the
examples package. First an algorithm definition is specified, using
``algorithm.genetic``, then it is composed into an optimised algorithm
instance, before finally the algorithm instance is run using ``run!``.

::
  
  # Provide a definition for the algorithm.
  def = algorithm.genetic() do alg
    alg.population = population.simple() do pop
      pop.size = 100

      # Species describes the fitness scheme and representation used by
      # individuals belonging to that species.
      pop.species = species.simple() do sp
        sp.fitness = fitness.scalar(Int)
        sp.representation = representation.bit_vector(100)
      end

      # Multi-threading breeding.
      pop.breeder = breeder.flat() do br
        br.threads = 8
        br.selection = selection.tournament(2)
        br.mutation = mutation.bit_flip(1.0)
        br.crossover = crossover.one_point(0.1)
      end
    end

    # Evaluation function (split across 8 threads).
    alg.evaluator = evaluator.simple(Dict{ASCIIString, Any}("threads" => 8)) do scheme, genome
      assign(scheme, sum(genome))
    end

    # Termination conditions.
    alg.termination["generations"] = criterion.generations(1000)
  end

  # Compose the algorithm from its definition.
  alg = compose!(def)

  # Run the composed algorithm.
  run!(alg)

Citation
========

If you plan on using Wallace for your research, we encourage you to cite the
paper below. Additionally, put in a merge request, and we will add your paper
to the list of papers using Wallace.

::

  @inproceedings{timperley2015wallace,
    author = {Timperley, Christopher Steven and Stepney, Susan},
    title = {Wallace: An efficient generic evolutionary framework},
    booktitle={ECAL 15},
    pages={365--372},
    year={2015},
    organization={MIT Press}
  }
