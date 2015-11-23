---
layout: page
title: Travelling Salesman Problem
permalink: /tutorials/tsp/
---

## The Problem

Could do with a short description of the problem being solved in this tutorial,
perhaps along with a diagram of the Berlin-52 map, and links to the .tsp file.

## Basic Setup
For this problem, we shall be using a standard evolutionary algorithm, with the
components listed below:

| Component           | Setting                                           |
| ------------------- | ------------------------------------------------- |
| Population          | Simple (single deme)                              |
| Representation      | Permutation                                       |
| Breeder             | Linear Breeder                                    |

### Solution Representation

As in the previous tutorial, we will once again be using the `simple` species to
describe our `simple` population. In this case, we will be using a `permutation`
representation to represent our potential solutions; each tour is represented
as an itinerary, where the cities are listed in the order in which they are
visited, except for the return trip to the starting city, which is left out as
that part of the journey is implicit.

Instances of the `permutation` representation are specified by providing an
alphabet of values which they should permute; this alphabet may contain any
type of item, from strings, to integers, to arbitary objects. One may provide
a alphabet to the specification either by explicitly stating it within a list,
by providing a numeric range, or by providing an external alphabet file.

If one were to take the explicit approach to representing the alphabet for the
given problem, then the specification would look something like that given
below:

<pre class="wallace">
_my_species&lt;species/simple&gt;:
  representation&lt;representation/permutation&gt;:
    alphabet: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,
      26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
      51,52]
</pre>

Clearly this approach is rather tedious and error-prone for our purposes,
especially if we were to use our algorithm to solve other instances of the TSP.

Alternatively, we could store our alphabet in an external line-delimited file,
and instead provide the alphabet property with the path to that file.

<pre class="wallace">
representation&lt;representation/permutation&gt;:
  alphabet: my_tsp_cities.txt
</pre>

However, exhaustively listing the indices of each of the cities in our problem,
whether inline or through an external alphabet file, is probably still a bit too
monotonous for our liking.

Fortunately, we can list the indices for each our cities in far more succinctly
through the use of numeric ranges, which are specified in exactly the same way
as they are within the Julia language.

<pre class="wallace">
representation&lt;representation/permutation&gt;:
  alphabet: 1:52
</pre>

## Setting up the Linear Breeder
The linear breeder is the second simplest breeder provided by Wallace; it
relaxes the constraints imposed on the type and number of genetic operators
imposed by the simple breeder, allowing the user to provide an arbitrary linear
chain of operators instead. Offspring are produced by being subjecting batches of
proto-offspring to each of these operators in sequence, until the desired number
the required number have been produced as directed.

To specify a linear breeder, one needs only to provide its definition with an
ordered list of operators, and if necessary, the stage of individual development
upon which they operate, as demonstrated below:

<pre class="wallace">
_my_breeder&lt;breeder/linear&gt;:
  operators:
    - type:   selection/tournament
      size:   4
      stage:  genome
    - type:   crossover/pmx
      stage:  genome
    - type:   mutation/2_opt
      stage:  genome
</pre>

However, since we're using a simple species, which has only a single stage of
development, there is no need for us to provide the `stage` property for each
operator specification. In the event we omitted the `stage` property and our
species had more than a single stage of development, then the stage would
default to the canonical genotype.

<pre class="wallace">
_my_breeder&lt;breeder/linear&gt;:
  operators:
    - type: selection/tournament
      size: 4
    - type: crossover/pmx
    - type: mutation/2_opt
</pre>

## Writing a Custom Evaluator

For our given problem we shall need to write an evaluator capable of
(quickly) calculating the round-trip distance of a given tour. The quickest way
to do is this to pre-calculate a distance (or cost) matrix, encoding the cost
of travelling from one city to another, rather than performing redundant
calculations at run-time.

However, this introduces the problem of pre-computing
and storing this matrix at the start of the computation, an ability that the
simple evaluator is uncapable of. To add this feature into our algorithm we'll
have to write our own evaluator from scratch.

In the interests of genericity, we'll write a new evaluator tailored specifically
to the Geometric Travelling Salesman Problem, capable of accepting a `.tsp` file
containing a list of city co-ordinates.

To add our own evaluator into Wallace, we'll need to write a *type manifest*
file and register it with Wallace, and in this case, we'll also need to write
a new Julia type to realise our evaluator.

### Julia Type

In order to implement our specialised TSP evaluator, we will first extend Wallace
with a new Julia type for that evaluator. To do this, we'll need to open up a new
Julia file (.jl) within our working directory, that we shall call
`my_tsp_evaluator.jl`. Within this file we will write a standard Julia definition
for a type that accepts details of a given TSP problem and evaluates provided
candidate solutions against them.

To create a new type within Julia, we simply write the keyword `type` followed
by the name of our type. The definition of our type then immediately follows this
line, and is terminated by the `end` keyword. However, as we're writing a special
type of evaluator, we will need to extend the base evaluator type, or to make our
lives a little easier, we'll be extending the `SimpleEvaluator` type; this is
done by following the syntax below.

<pre class="julia">
type MyTSPEvaluator &lt;: SimpleEvaluator

end
</pre>

Next, we shall define the attributes of our TSP evaluator type within the type
definition block we have just created. This is done by simply providing the name
of the attribute followed by two colons and the name of its underlying type within
Julia. An example attribute, responsible for recording the number of cities within
a given TSP instance is shown below.

<pre class="julia">
type MyTSPEvaluator &lt;: SimpleEvaluator
  cities::Int
end
</pre>

For our particular evaluator, we shall add two further attributes to its
definition; namely, `threads`, specifying the number of threads that the
evaluation workload should be split across, and `distance`, modelling the
distance matrix between nodes. To model the distance matrix, we shall make use
of Julia's multi-dimensional arrays, using an efficient two-dimensional array
to store the distance between nodes. The complete definition for this type
is given below:

<pre class="julia">
type MyTSPEvaluator &lt;: SimpleEvaluator
  cities::Int
  threads::Int
  distance::Array{Int, 2}
end
</pre>

With our type definition in place, we now need to implement the `evaluate!`
method of our type, responsible for accepting an individual, along with the
state of the search, and returning a valid fitness object. The `evaluate!`
method for individual evaluation should accept the following arguments:

* `e::MyTSPEvaluator` - The evaluator object itself must be provided as part
of the call. From this object we will extract the distance matrix to perform
the tour length calculations.
* `s::State` - The current state of the evolution. We won't be using this,
but as it forms a necessary part of the `evaluate!` method signature, we shall
still include it.
* `sch::FitnessScheme` - The fitness scheme used by the provided individual.
We will use this to produce a fitness object from its tour length using the
`fitness()` method.
* `c::Individual` - The individual being passed for evaluation. We will access
its `genome` property to extract details of the tour.

Once we've added these method arguments together, our empty method should
start to look something like the example below.

<pre class="julia">
function evaluate!(e::MyTSPEvaluator, s::State, sch::FitnessScheme, c::Individual)

end
</pre>

Ultimately our method should return a computed fitness object for its provided
individual. In order to do this, we will call the `fitness` method, together with
the fitness schema and the individual's tour length as its arguments, as shown
below.

<pre class="julia">
function evaluate!(e::MyTSPEvaluator, s::State, sch::FitnessScheme, c::Individual)
  fitness(sch, length)
end
</pre>

Now the last thing that remains is to add the tour length calculation logic
into the top of our method body. In order to do this, the first thing that we should
do is retrieve the tour from the provided individual, by calling `get(c.genome)`.

<pre class="julia">
function evaluate!(e::MyTSPEvaluator, s::State, sch::FitnessScheme, c::Individual)
  tour = get(c.genome)

  fitness(sch, length)
end
</pre>

Next, we want to create a temporary variable to store the total length of the
individual's tour. Let's simply call this `length`. Without a little knowledge
about the inner workings of Julia, you may be tempted to simply perform this
operation via `length = 0`. But that would be a near-silent mistake, resulting
in a slower performance and some strange artefacts.

Why? Because setting the length to `0` will mark the length variable as an
integer, and any subsequent operations will either proceed to convert the
integer to a floating point, or they will simply treat inputs as integers.

The simplest way to get round this is to initialise a floating point zero via
`0.0`, but a safer, better practice, is to initialise the count using the
`zero` function with the name of the underlying type, as shown below.

<pre class="julia">
function evaluate!(e::MyTSPEvaluator, s::State, sch::FitnessScheme, c::Individual)
  tour = get(c.genome)
  length = zero(Float)

  fitness(sch, length)
end
</pre>

We now need to actually perform the tour length calculation. The fastest and
simplest way to do this is to simply iterate across the indices of each of the
cities, from 1 to the number of cities minus one, intentionally missing the
last index. At each step, we then increment the tour length by the distance
between the city at the current index and the city at the subsequent index
using the distance matrix. Finally, we add the distance between the city at
the final index and the starting index to complete the tour.

We should now have a complete type definition for our evaluator that looks
something like the one below.

<pre class="julia">
type MyTSPEvaluator &lt;: SimpleEvaluator
  cities::Int
  threads::Int
  distance::Array{Int, 2}
end

function evaluate!(e::MyTSPEvaluator, s::State, sch::FitnessScheme, c::Individual)
  tour = get(c.genome)
  length = zero(Float)
  for i in 1:e.cities-1
    length += e.distance[tour[i], tour[i+1]]
  end
  length + e.distance[tour[end], tour[1]]
  fitness(sch, length)
end
</pre>

### Wallace Type Manifest

With our type definition in place, we now need to write a manifest for our
type, describing its internal structure and composer to Wallace. To do this,
let's begin by creating a new manifest file, `tsp.manifest.yml`.

At the top of our type manifest file, we should add a `type` property,
specifying the name of the type that is being registered with Wallace;
note that this name needn't be the same as the name of the Julia type.
The name of our evaluator should follow Wallace's type naming conventions.
Firstly, the name of the package, if any, that the type belongs to
should appear first, followed by a colon. Then the name of the base type,
if any, should appear, followed by a forward slash. Finally, the name of
the type itself should appear at the end. An example type name for our
problem is given below:

<pre class="yaml">
type: evaluator/tsp
</pre>

With the name of our type in place, we now need to provide the manifest
file with the following information:

* `description` - A short description of the purpose and function of the type.
* `properties` - An associated array (dictionary/hash) describing the parameters
    of this type, indexed by the name of each parameter. Each entry should
    contain a `description`, a `type`, and optionally, a `default` tag,
    describing, but not specifying, the default value / behaviour of the property.
* `composer` - Provides the body of a Julia function, responsible for creating
  and returning an instance of the given type from a set of provided parameters.

To begin with, let's write a short description for our type. Below is an
example of a simple description. For those less familiar with YAML, the `|` symbol
following the `description` property marks the beginning of a multi-line string
on the line below.

<pre class="yaml">
type: alfred:evaluator/tsp

description: |
  Evaluates the fitness of a TSP tour for a pre-determined set of cities.
</pre>

Next, let's put together a list of the properties for our TSP evaluator. For
our problem we would like our evaluator to accept a file containing the
co-ordinates of a set of cities for our particular problem, as well as a
property instructing the evaluator how many threads the process should be
split across. Below we give an example of how this might be added to the
manifest file. 

<pre class="yaml">
type: alfred:evaluator/tsp

description: |
  Evaluates the fitness of a TSP tour for a pre-determined set of cities.

properties:
  threads:
    type:         Integer
    description:  &gt; The number of threads that the evaluation process should be
      split across.

  file:
    type:         String
    description:  &gt; The path to the file containing the co-ordinates of each of
</pre>

Finally, we need to write a composer, which we will accept a set of parameters,
provided by `s`, and should construct an instance of the Julia type using them.
For our TSP evaluator, our composer will need to take the path to a file
containing the co-ordinates of a set of cities, and to load and transform the
contents of that file into a distance matrix.

In order to generate a distance matrix within the composer, we first need to
load the contents of the cities file and convert it into an array of co-ordinates.
The easiest way to do this is to first create an empty list to hold the
co-ordinate lists for each city, and to then scan each line in the TSP file,
convert it into a list of co-ordinates, and insert it into the array. A way of
performing the above in Julia is given below.

<pre class="julia">
# Create a list to hold the co-ordinates of each city.
cities = Vector{Float}[]

# Open up a handle on the TSP city file with read permissions.
f = open(s["file"], "r")

# Iterate across each line in the file, and provided it isn't empty,
# produce a list of co-ordinates from it and append them to the
# city co-ordinates list.
for l in readlines(f)
  !isempty(l) && push!(cities, [float(n) for n in split(l, ",")])
end

# Close the file handle.
close(f)
</pre>

Now we have a way of computing the list of co-ordinates for each city,
let's go about calculating the distance matrix. As we did before, in
our type definition, we shall use a two-dimensional array to
implement our distance matrix. A simple way to compute this matrix is
given below:

<pre class="julia">
n = length(cities)
matrix = Array(Float, 2)
for i = 1:n
  for j = 1:n
    matrix[i, j] = sqrt(sum((cities[i] - cities[j]) .^ 2))
  end
end
</pre>

We now have everything in place to build an instance of our TSP
evaluator type, and to complete our composer. We simply need to pass
the number of cities, the number of threads, and the distance matrix
to the TSP evaluator constructor (in the order in which they appear
in the type definition). The only additional step we need to take is
to provide a default number of threads.

A complete example of our manifest file is given below.

<pre class="yaml">
type: alfred:evaluator/tsp

description: |
  Evaluates the fitness of a TSP tour for a pre-determined set of cities.

properties:
  threads:
    type:         Integer
    description:  &gt; The number of threads that the evaluation process should be
      split across.

  file:
    type:         String
    description:  &gt; The path to the file containing the co-ordinates of each of
      the cities for the TSP instance being solved.

     the cities for the TSP instance being solved.

composer: |

  # Create a list to hold the co-ordinates of each city.
  cities = Vector{Float}[] 
  
  # Open the text file up, remove any empty lines, convert remaining lines
  f = open(s["file"], "r")
 
  # Count the number of cities
  n = length(cities)

  # From the list of cities, compute distance matrix.
  matrix = Array(Float, 2)
  for i = 1:n
    for j = 1:n
      matrix[i, j] = sqrt(sum((cities[i] - cities[j]) .^ 2))
    end
  end

  # Default to a single thread of evaluation.
  s["threads"] = get(s, "threads", 1)
 
  # Create an instance of the TSP evaluator type.
  MyTSPEvaluator(n, s["threads"], matrix)  
</pre>

## Running the Algorithm

After having followed all the preceding steps, you should have an algorithm
that roughly looks similar to the one given below:

<pre class="wallace">
type: algorithm/evolutionary_algorithm

evaluator&lt;evaluator/tsp&gt;:
  cities: berlin52.tsp

termination:
  evaluations&lt;criterion/evaluations&gt;: { limit: 100000 }

_my_species&lt;species/simple&gt;:
  representation&lt;representation/permutation&gt;:
    alphabet: 1:52 

_my_breeder&lt;breeder/linear&gt;:
  operators:
    - type: selection/tournament
      size: 4
    - type: crossover/pmx
    - type: mutation/2_opt

population&lt;population/simple&gt;:
  size:     100
  breeder:  $(_my_breeder)
  species:  $(_my_species)
</pre>
