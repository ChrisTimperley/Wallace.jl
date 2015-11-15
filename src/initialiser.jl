module initialiser
using population, _deme_, core
export Initialiser, initialise!

"""
The base type used by all initialisers.
"""
abstract Initialiser

"""
Initialises all members within a given population.
"""
initialise!(init::Initialiser, p::Population) = for d in p.demes
  initialise!(init, d)
end

"""
Initialises all members within a given deme.
"""
initialise!(init::Initialiser, d::Deme) = for i in 1:d.capacity
  initialise!(init, i)
end

"""
The default initialiser used by all evolutionary algorithms.
"""
type DefaultInitialiser <: Initialiser; end

function initialise!(i::DefaultInitialiser, d::Deme)
  rep = d.species.genotype.representation
  d.members[d.species.genotype.label] = [rand(rep) for i in 1:d.capacity]
end

end
