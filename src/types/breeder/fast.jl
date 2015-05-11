load("../breeder.jl",           dirname(@__FILE__))
load("fast/breeder_source.jl",  dirname(@__FILE__))

# Lots of optimisation opportunities here!
type FastBreeder <: Breeder

  # The eigentype for this breeder.
  eigen::Type

  # The terminal source of this breeder.
  source::BreederSource

  # Maintain buffers?

  # Maintain the offspring buffers if all the numbers are static?

  FastBreeder(species::Species, src::BreederSource) =
    new(anonymous_type(Wallace), src)
end

# Returns a list of the sources to a breeding operation or a breeder.
sources(s::Union(VariationBreederSource, FastBreeder)) = if isa(s.source, MultiBreederSource)
  return s.source.sources
else
  return BreederSource[s.source]
end

# Could we perform this breeding in-place?
breed!(b::FastBreeder, d::Deme) =
  d.offspring = breed!(d.species, b.source, d, d.num_offspring, b)

# Produces a requested number of (proto-)offspring from a multiple breeding source.
function breed!{I <: Individual}(
  sp::Species,
  s::MultiBreederSource,
  d::Deme{I},
  n::Int,
  caller::Union(FastBreeder, BreederSource)
)
  proportions = proportion(n, s.proportions)
  vcat([breed!(s.sources[i], d, proportions[i], caller) for i in 1:length(s.sources)])
end

# Produces a requested number of individuals for breeding using a given selection source.
# Each selected individual is cloned to avoid changes to the original population.
function breed!(
  sp::Species,
  s::SelectionBreederSource,
  d::Deme,
  n::Int,
  caller::Union(FastBreeder, BreederSource)
)# =
#  sync(s.eigen, caller.eigen, sp, map!(clone, select(s.operator, d.members, n)))
  inds = select(s.operator, d.members, n)
  map!(clone, inds)
  sync(s.eigen, caller.eigen, sp, inds)
end

function breed!{I <: Individual}(
  sp::Species,
  s::VariationBreederSource,
  d::Deme{I},
  n::Int64,
  caller::Union(FastBreeder, BreederSource)
)
  # Full-time cache?

  # Cache the number of inputs and outputs to this operator.
  op_inputs = num_inputs(s.operator)
  op_outputs = num_outputs(s.operator)

  # Cache.
  buffer_individuals = Array(I, op_inputs)

  # Calculate the number of calls to the operator that are necessary to
  # produce the desired number of individuals.
  calls = iceil(n / op_outputs)

  # Generate the necessary input proto-offspring.
  inputs = breed!(sp, s.source, d, calls * op_outputs, s)

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

# Register this type.
register("breeder/fast", FastBreeder)
composer("breeder/fast") do s

  # Determine the correct order in which to construct each of the breeding
  # sources.
  srcs = collect(keys(Dict{String, Any}(s["sources"])))
  i = 1
  while i < length(srcs)
    gt_i = findfirst(srcs) do j
      srcs[i] == s["sources"][srcs[j]]["source"]
    end
    if gt_i != 0 && gt_i > i
      srcs[gt_i], srcs[i] = srcs[i], srcs[gt_i]
    else
      i += 1
    end
  end

  # Create each of the breeding sources, in the established order.
  for sn in srcs
    ss = s["sources"][sn]
    if ss["type"] == "variation" && haskey(ss, "source")
      ss["source"] = s["sources"][ss["source"]]
      ss["stage"] = s["species"].stages[Base.get(ss, "stage", "genome")]
    end
    s["sources"][sn] = compose_as(ss, "breeder/fast:source/$(ss["type"])")
  end
  
  # Create the breeder using the final breeding source.
  # Annoyingly OrderedDict doesn't implement an endof(), nor does
  # its iterator, and so we have to collect its values before determining
  # which is the last.
  build_sync(s["species"], FastBreeder(s["species"], s["sources"][srcs[end]]))
end
