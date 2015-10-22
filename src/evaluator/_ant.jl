type Ant
  score::Int
  moves::Int
  orientation::Int # North, East, South, West
  pos_x::Int
  pos_y::Int
  lim_x::Int
  lim_y::Int
  max_moves::Int
  max_score::Int
  map::Array{Bool, 2} #(x,y)
  sources::Vector{Tuple{Int, Int}}
  
  Ant(max_moves::Int, map::Array{Bool, 2}) = 
    build(new(0, 0, 1, 1, 1, size(map, 1), size(map, 2), max_moves, 0, map))
end

function left(a::Ant)
  a.moves += 1
  a.orientation = max(min(a.orientation - 1, 3), 0)
end

function right(a::Ant)
  a.moves += 1
  a.orientation = max(min(a.orientation + 1, 3), 0)
end

food_ahead(a::Ant) =
  a.map[next_cell_x(a), next_cell_y(a)]

next_cell_x(a::Ant) = if a.orientation == 1
  min(a.pos_x + 1, a.lim_x)
elseif a.orientation == 3
  max(a.pos_x - 1, 1)
else
  a.pos_x 
end

next_cell_y(a::Ant) = if a.orientation == 0
  max(a.pos_y - 1, 1)
elseif a.orientation == 2
  min(a.pos_y + 1, a.lim_y)
else
  a.pos_y
end

function move(a::Ant)
  a.moves += 1
  a.pos_x = next_cell_x(a)
  a.pos_y = next_cell_y(a)
  if a.map[a.pos_x, a.pos_y] && a.moves <= a.max_moves && a.score <= a.max_score
    a.map[a.pos_x, a.pos_y] = false
    a.score += 1
  end
end

function reset!(a::Ant)
  a.pos_x = 1
  a.pos_y = 1
  a.orientation = 1
  a.moves = 0
  a.score = 0
  for (x,y) in a.sources
    a.map[x,y] = true
  end
end

function build(a::Ant)
  a.sources = []
  for x in 1:size(a.map, 1)
    for y in 1:size(a.map, 2)
      if a.map[x, y]
        a.max_score += 1
        push!(a.sources, (x,y))
      end
    end
  end
  return a
end

draw(a::Ant, x::Int, y::Int, b::Bool) = if x == a.pos_x && y == a.pos_y
  'X'
elseif b
  '#'
else
  ' '
end

describe(a::Ant) =
  join([join([draw(a, x, y, a.map[x,y]) for x in 1:a.lim_x],"") for y in 1:a.lim_y], "\n")

function load_trail(path::AbstractString)

  # Load the contents of the trail file.
  f = open(path)
  lines = readlines(f)
  close(f)

  # Find the dimensions of the trail.
  dims = [parse(Int, i) for i in Base.split(Base.strip(shift!(lines)), " ")]

  # Construct the trail, row by row.
  trail = Array(Bool, dims[1], dims[2])
  for y in 1:dims[2]
    for x in 1:dims[1]
      trail[x,y] =
        !(y > length(lines)) &&
        !(x > length(lines[y])) &&
        lines[y][x] == '#'
    end
  end
  return trail

end

"""
An evaluator, specialised to the artifical ant problem.
"""
type AntEvaluator <: SimpleEvaluator
  ant::Ant
  AntEvaluator(ant::Ant) = new(ant)
end

#function evaluate!(e::AntEvaluator, s::State, sc::FitnessScheme, c::Individual)
#  while e.ant.moves < e.ant.max_moves && e.ant.score < e.ant.max_score
#    execute(get(c.genome), e.ant)
#  end
#  score = e.ant.score
#  reset!(e.ant)
#  fitness(sc, score)
#end

"""
An evaluator, specialised for the artifical ant problem.

**Properties:**

* `moves::Int`, the maximum number of moves the ant is permitted to make.
* `trail::AbstractString`, the path to the file describing the trail for this problem.
"""
ant(s::Dict{Any,Any}) = AntEvaluator(Ant(s["moves"], load_trail(s["trail"])))
