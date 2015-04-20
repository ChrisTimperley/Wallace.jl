load("individual.jl",   dirname(@__FILE__))

abstract Representation

chromosome(r::Representation) =
  error("No `chromosome` representation for $(typeof(r)).")

function convert!{I <: Individual}(
  r_from::Representation,
  r_to::Representation,
  n_from::String,
  n_to::String,
  inds::Vector{I}
)
  getter = eval(parse("i -> i.$(n_from)"))
  setter = eval(parse("i -> i.$(n_to)"))
  for i in inds
    convert!(r_from, r_to, getter(i), setter(i))
  end
  return inds
end

describe(i::Any) = "$(i)"

register("representation", Representation)
