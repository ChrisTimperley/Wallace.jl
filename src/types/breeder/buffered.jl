load("../individual",         dirname(@__FILE__))
load("../deme",               dirname(@__FILE__))
load("../breeder",            dirname(@__FILE__))
load("../operator",           dirname(@__FILE__))
load("../operator/selection", dirname(@__FILE__))
load("../operator/variation", dirname(@__FILE__))

type BufferedBreeder <: Breeder

  # A dictionary containing the operators used by this breeder,
  # indexed by their unique names.
  #
  # - Quite inefficient.
  # - We only ever use this during construction!
  operators::Dict{ASCIIString, Operator}

  # An array of the terminal operators within this breeder.
  # ---- Should be weighted!
  terminals::Array{Operator, 1}

  # An dictionary containing the source for each variation operator.
  sources::Dict{Operator, Operator}

  # Constructs a new buffered breeder.
  BufferedBreeder() =
    new(Dict{ASCIIString, Operator}(), Operator[], Dict{Operator, Operator}())

end

# Attaches a new operator to this breeder.
function add!(
  breeder::BufferedBreeder,
  name::ASCIIString,
  operator::Operator
)
  # Ensure that the name given to this operator isn't already in use.
  if haskey(breeder.operators, name)
    throw(ArgumentError("Operator name already in use: $(name)."))
  end
  breeder.operators[name] = operator
end

# Attaches a new variation operator to this breeder.
function add!(
  breeder::BufferedBreeder,
  name::ASCIIString,
  operator::Variation,
  source::ASCIIString
)
  invoke(add!, (BufferedBreeder, ASCIIString, Operator), breeder, name, operator)
  breeder.sources[operator] = breeder.operators[source]
end

function build!(breeder::BufferedBreeder)

  # Produce a set of all the operators attached to this breeder.
  terminals = Set{Operator}(values(breeder.operators))

  # Iterate over the list of operator sources, removing each source from the
  # list of operators.
  for source in values(breeder.sources)
    delete!(terminals, source)
  end

  # Constructor the terminals for the breeder.
  # - Could perform weighting here.
  breeder.terminals = collect(terminals)

end

function breed!(breeder::BufferedBreeder, deme::Deme)

  # Prepare the buffers for this thread.
  buffers = Dict{Operator, Array{Individual, 1}}()
  for o in values(breeder.operators)
    buffers[o] = prepare(o, deme.members)
  end

  # Single-threaded for now.
  for i in 1:deme.num_offspring
    deme.offspring[i] = produce!(breeder, breeder.terminals[rand(1:end)], buffers, 1)[1]
  end

end

# Produces a requested number of (proto-)offspring.
#
# ==== Parameters
# [+breeder+]   The buffered breeder being used to generate the offspring for this deme.
# [+operator+]  The variation operator to use to produce a given number of individuals.
# [+buffers+]   The buffers for each operator within this breeder.
# [+num+]       The number of individuals that should be produced using this breeder.
function produce!(
  breeder::BufferedBreeder,
  operator::Variation,
  buffers::Dict{Operator, Array{Individual, 1}},
  num::Int64
)
  while length(buffers[operator]) < num
    inputs = produce!(breeder, breeder.sources[operator], buffers, num_inputs(operator))
    outputs = operate!(operator, map((i) -> i.genome, inputs))
    for (ind, d) in zip(inputs, outputs)
      ind.genome = d
    end
    append!(buffers[operator], inputs)
  end
  return splice!(buffers[operator], 1:num) 
end

# Produces a requested number of (proto-)offspring.
#
# ==== Parameters
# [+breeder+]   The buffered breeder being used to generate the offspring for this deme.
# [+operator+]  The selection operator to use to produce a given number of individuals.
# [+buffers+]   The buffers for each operator within this breeder.
# [+num+]       The number of individuals that should be produced using this breeder.
function produce!(
  breeder::BufferedBreeder,
  operator::Selection,
  buffers::Dict{Operator, Array{Individual, 1}},
  num::Int64
)
  map(clone, select!(operator, buffers[operator], num))
end

# Register this type.
register("breeder/buffered", BufferedBreeder)
