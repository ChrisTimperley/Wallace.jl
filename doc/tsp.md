---
layout: page
title: Travelling Salesman Problem
permalink: /tutorials/tsp/
---

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
