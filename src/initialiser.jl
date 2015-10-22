module initialiser
using population, _deme_, core

"""
The base type used by all initialisers.
"""
abstract Initialiser

"""
Initialises all members within a given population.
"""
initialize!(i::Initialiser, p::Population) = for d in p.demes
  initialize!(i, d)
end

"""
Initialises all members within a given deme.
"""
initialize!{I <: Individual}(i::Initialiser, d::Deme{I}) = for ind in d.members
  initialize!(i, ind)
end

"""
The default initialiser used by all evolutionary algorithms.
"""
type DefaultInitialiser <: Initialiser
end

function initialise!{I <: Individual}(i::DefaultInitialiser, d::Deme{I})
  rep = d.species.genotype.representation
  getter = eval(Base.parse("i -> i.$(d.species.genotype.label)")) # TODO: Not a big fan.
  for ind in d.members
    getter(ind).value = rand(rep)
  end
end

end
