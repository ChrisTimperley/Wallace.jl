"""
An evaluator specialised to the travelling salesman problem.
"""
type TSPEvaluator <: Evaluator
  stage::AbstractString
  cities::Int
  threads::Int
  distance::Array{Float, 2}

  TSPEvaluator(st::AbstractString, n::Int, t::Int, d::Array{Float, 2}) =
    new(st, n, t, d)
end

"""
Contains a definition of a TSP evaluator.
"""
type TSPEvaluatorDefinition <: EvaluatorDefinition
  stage::AbstractString
  file::AbstractString
  threads::Int

  TSPEvaluatorDefinition() = new("", "", 1)
  TSPEvaluatorDefinition(s::AbstractString, f::AbstractString, t::Int) =
    new(s, f, t)
end

"""
Composes a TSP evaluator from its definition.
"""
function compose!(ev::TSPEvaluatorDefinition, p::Population)
  # Find the name of the stage that is used for evaluation if none is provided.
  if ev.stage == ""
    ev.stage = p.demes[1].species.genotype.label
  end

  # Load the contents of the file and convert into a list of co-ordinates.
  coords = open(ev.file, "r") do f
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
  return TSPEvaluator(ev.stage, num, ev.threads, matrix)
end

"""
Evaluates the fitness of a TSP tour for a pre-determined geometric problem.

**Positional Arguments**:

* `file::AbstractString`, the path to the file containing the co-ordinates of
  each of the cities for the geometric TSP instance being solved, relative to
  the current working directory.

**Keyword Arguments**:

* `threads::Int`, the number of threads that the evaluation process should be
  split across. Defaults to `1`.
"""
tsp(file::AbstractString; stage::AbstractString = "", threads = 1) =
  TSPEvaluatorDefinition(stage, file, max(1, threads))

"""
Computes the length of a provided tour and transforms it into a fitness value
according to a provided fitness scheme.
"""
function evaluate!(e::TSPEvaluator, sch::FitnessScheme, tour::Vector{Int})
  length = zero(Float)
  for i in 1:(e.cities - 1)
    length += e.distance[tour[i], tour[i+1]]
  end
  length += e.distance[tour[end], tour[1]]
  assign(sch, length)
end
