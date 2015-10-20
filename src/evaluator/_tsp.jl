"""
An evaluator specialised to the travelling salesman problem.
"""
type TSPEvaluator <: SimpleEvaluator
  cities::Int
  threads::Int
  distance::Array{Float, 2}

  TSPEvaluator(d::Array{Float, 2}, t::Int) =
    new(size(d, 1), t, d)
end

"""
Evaluates the fitness of a TSP tour for a pre-determined geometric problem.

**Properties**:

* `threads::Int`, the number of threads that the evaluation process should be
  split across.
* `file::String`, the path to the file containing the co-ordinates of each of
  the cities for the geometric TSP instance being solved, relative to the
  current working directory.
"""
function tsp(s::Dict{Any, Any})

  # Determine number of threads to use.
  s["threads"] = int(Base.get(s, "threads", 1))
  s["threads"] = max(1, s["threads"])

  # Load the contents of the file and convert into a list of co-ordinates.
  coords = open(s["file"], "r") do f
    c = Vector{Float}[]
    for ln in eachline(f)
      !isempty(ln) && push!(c, Float[float(x) for x in split(ln)]) 
    end
    c
  end
  num = length(coords)

  # Generate a distance matrix from the set of co-ordinates.
  matrix = Array(Float, num, num)
  for i = 1:num
    for j = 1:num
      matrix[i, j] = sqrt(sum((coords[i] - coords[j]) .^ 2))
    end
  end

  # Build and return the evaluator.
  return TSPEvaluator(matrix, s["threads"])
end

"""
function evaluate!(e::TSPEvaluator, s::State, sch::FitnessScheme, c::Individual)
  tour = get(c.genome)
  length = zero(Float)
  for i in 1:(e.cities - 1)
    length += e.distance[tour[i], tour[i+1]]
  end
  length += e.distance[tour[end], tour[1]]
  fitness(sch, length)
end
"""
