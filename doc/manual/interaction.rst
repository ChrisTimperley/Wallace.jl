Interaction
========================

Julia Read-Eval-Print-Loop (REPL)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

IJulia Graphical Notebook
~~~~~~~~~~~~~~~~~~~~~~~~~

Another way to interact with Wallace is through the IJulia, a powerful
graphical web-based notebook front-end for Julia.

::

    julia> using IJulia
    julia> notebook()

    ijulia> using Wallace

Script Execution
~~~~~~~~~~~~~~~~

Alternatively, one may choose to import the Wallace package into a Julia
script, which may then be executed via the command line, as shown below:

::

    shell> julia my_script.jl

--------------

Loading Wallace Files
---------------------

The ``compose`` function may be used to build the Julia object described
by a given Wallace specification file into a concrete form. When called
with only the name of the file that should be composed, Wallace will
attempt to determine how to construct the object based upon its
top-level ``type`` property.

::

    julia> alg = compose("my_algorithm.cfg")

In the event that a specification file does not have a top-level
``type`` property, or one wishes to build it as a specific type, one may
use the ``compose_as`` function to instruct Wallace to attempt to build
the object from the description as if it were a given type.

::

    julia> alg = compose_as("my_algorithm.cfg", "algorithm/simple_evolutionary_algorithm")

Modifications may be made to a given specification before translation,
without affecting the original file, by supplying either the
``compose_with`` or ``compose_as_with`` functions with a block that
accepts a given parsed specification object and performs changes to that
object.

::

    julia> alg = compose_with("my_algorithm.cfg") do cfg
      cfg["population_size"] = 100
    end

    julia> alg = compose_as_with("my_algorithm.cfg", "algorithm/simple_evolutionary_algorithm") do cfg
      cfg["population_size"] = 100
    end

--------------

Navigational Commands
---------------------

``help`` function
~~~~~~~~~~~~~~~~~

Describing types
^^^^^^^^^^^^^^^^

::

    julia> help("selection/tournament")

    Authors: Alice and Bob

Describing type properties
^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    julia> help("selection/tournament:size")
    The number of individuals that should participate in each tournament.

    Type:     Integer
    Default:  5

``listall`` function
~~~~~~~~~~~~~~~~~~~~

The ``listall`` function can be used to produce a list of all the known
sub-types of a given type that have been loaded into the Wallace
environment.

::

    julia> listall("selection")
    - selection/tournament
    - selection/roulette
    - selection/stochastic_universal_sampling
    - selection/random
    - selection/truncation

function **aliases**\(**type**)

Returns a list of all known aliases for a given property or type.

::

    julia> aliases("selection/stochastic_universal_sampling")
    - selection/stochastic_universal_sampling
    - selection/sus

    julia> aliases("mutation/bit_flip#rate")
    - #rate
    - #probability

``version`` function

To see which version of Wallace you're running on your system, you may
make use of the provided ``version`` function.

::

    julia> Wallace.version()
    v"0.0.1"

``examples`` function

The ``examples`` function can be used to return a list of all the
official example solutions bundled with your current version of Wallace.

::

    julia> Wallace.examples()
    - ant
    - koza
    - multiplexer
    - one_max
    - rastrigin
    - symbolic_regression

To load the algorithm for one of these examples, one may use the
``example`` function with the name of the example problem you wish to
build:

::

    julia> alg = Wallace.example("ant");
    julia> results = run!(alg);

