load("../initializer.jl",    dirname(@__FILE__))
load("../representation.jl", dirname(@__FILE__))

type DefaultInitializer <: Initializer
end

function initialize!{I <: Individual}(i::DefaultInitializer, d::Deme{I})
  rep = d.species.genotype.representation
  getter = eval(Base.parse("i -> i.$(d.species.genotype.label)"))
  for ind in d.members
    getter(ind).value = rand(rep)
  end
end
