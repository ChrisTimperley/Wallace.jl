module initialiser
using population, _deme_, core, fitness, representation, individual
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

"""
Initialises a given deme by generating its contents at pseudo-random according
to its default generator method.
"""
function initialise!(i::DefaultInitialiser, d::Deme)
  rep = d.species.genotype.representation
  chromo = chromosome(rep)
  d.members.fitnesses = d.offspring.fitnesses = Array(uses(d.species.fitness), d.capacity)
  d.members.stages[d.species.genotype.label] =
    d.offspring.stages[d.species.genotype.label] =
    IndividualStage{chromo}[IndividualStage{chromo}(generate(rep)) for i in 1:d.capacity]
end

end
