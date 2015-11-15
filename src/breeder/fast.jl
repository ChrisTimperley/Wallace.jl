type FastBreeder <: Breeder
  # The eigentype for this breeder.
  eigen::Type

  # The terminal source of this breeder.
  source::BreederSource

  FastBreeder() = new()
end

"""
Provides a definition for composing a fast breeder.
"""
type FastBreederDefinition <: BreederDefinition
  """
  A list containing definitions for the different sources used by this breeder.
  """
  sources::Vector{BreederSourceDefinition}
end

"""
Composes a fast breeder from a provided definition.
"""
function compose!(def::FastBreederDefinition, species::Species)
  b = FastBreeder()
  b.eigen = anonymous_type(breeder)

  # Construct a dictionary containing the sources for this breeder, indexed by
  # their labels.
  sd_dict = Dict{AbstractString, BreederSourceDefinition}(
    [(s.label, s) for s in def.sources] 
  )
  labels = map(s -> s.label, def.sources)

  # Calculate the order of the breeding sources.
  i = 1
  while i < length(labels)
    gt_i = findfirst(labels) do j
      isa(sd_dict[labels[i]], VariationBreederSourceDefinition) &&
        sd_dict[labels[i]].source == j
    end
    if gt_i != 0 && gt_i > i
      labels[gt_i], labels[i] = labels[i], labels[gt_i]
    else
      i += 1
    end
  end

  # Compose each of the breeding sources, in the established order.
  sources = Dict{AbstractString, BreederSource}()
  for label in labels
    sources[label] = compose!(sd_dict[label], species, sources)
  end

  # Determine the terminal breeding source.
  b.source = sources[labels[end]]

  # Build the synchronisation operations.
  build_sync(species, b)
  b
end

"""
TODO: Document breeder.fast
"""
fast(sources::Vector{BreederSourceDefinition}) =
  FastBreederDefinition(sources)

# Returns a list of the sources to a breeding operation or a breeder.
sources(s::Union{VariationBreederSource, FastBreeder}) = if isa(s.source, MultiBreederSource)
  return s.source.sources
else
  return BreederSource[s.source]
end

breed!(
  b::FastBreeder,
  s::Species,
  members::IndividualCollection,
  capacity::Int,
  num_offspring::Int
) =
  breed!(b.source, s, members, num_offspring, b)

"""
Produces a requested number of (proto-)offspring from a multiple breeding source.
"""
function breed!(
  s::MultiBreederSource,
  sp::Species,
  members::IndividualCollection,
  n::Int,
  caller::Union{FastBreeder, BreederSource}
)
  proportions = proportion(n, s.proportions)
  vcat([breed!(s.sources[i], sp, members, proportions[i], caller) for i in 1:length(s.sources)])
end

# Produces a requested number of individuals for breeding using a given selection source.
# Each selected individual is cloned to avoid changes to the original population.
function breed!{I <: Individual}(
  s::SelectionBreederSource,
  species::Species,
  members::Vector{I},
  n::Int,
  caller::Union{FastBreeder, BreederSource}
)
  inds = select(s.operator, species, members, n)
  map!(clone, inds)
  sync(s.eigen, caller.eigen, species, inds)
end

function breed!{I <: Individual}(
  s::VariationBreederSource,
  sp::Species,
  members::Vector{I},
  n::Int,
  caller::Union{FastBreeder, BreederSource}
)
  # Full-time cache?

  # Cache the number of inputs and outputs to this operator.
  op_inputs = num_inputs(s.operator)
  op_outputs = num_outputs(s.operator)

  # Cache.
  buffer_individuals = Array(I, op_inputs)

  # Calculate the number of calls to the operator that are necessary to
  # produce the desired number of individuals.
  calls = ceil(Integer, n / op_outputs)

  # Generate the necessary input proto-offspring.
  inputs = breed!(s.source, sp, members, calls * op_outputs, s)

  # Now we need to synchronise the representation graph of our proto-offspring, such
  # that the stage that this operator works on is marked as clean.
  
  # If we're calling another variator directly, then we simply need to call a
  # lambda function, "prepare", which is applied to a homogeneous array of individuals.

  # But if our individuals come from a multi-source, we need to prepare each source
  # in a different way.

  # Produce the offspring.
  outputs = Array(I, calls * op_outputs)
  outputs_to = 0
  for c in 1:calls
    inputs_to = op_inputs * c
    inputs_from = inputs_to - op_inputs + 1

    outputs_to = op_outputs * c
    outputs_from = outputs_to - op_outputs + 1

    # Lots of room for optimisation.
    buffer_individuals = inputs[inputs_from:inputs_to]
    
    call!(s.operator, s.stage_getter, buffer_individuals)
    #operate!(s.operator, map(s.stage, buffer_individuals))

    outputs[outputs_from:outputs_to] = buffer_individuals
  end

  # Limit the number of produced offspring to the number desired.
  # (Is it faster to limit, or to not produce more than you need?)
  return sync(s.eigen, caller.eigen, sp, outputs[1:n])
end

# Load the components of this breeder.
include("fast/builder.jl")
