type ComplexSpeciesSpecification
  fitness::FitnessScheme
  stages::Vector{SpeciesStage}

  ComplexSpeciesSpecification() =
    new(fitness.scalar())
  ComplexSpeciesSpecification(st::Vector{SpeciesStage}) =
    new(fitness.scalar(), st)
  ComplexSpeciesSpecification(f::FitnessScheme, st::Vector{SpeciesStage}) =
    new(f, st)
end

"""
Composes a complex species from a provided specification.
"""
function compose!(c::ComplexSpeciesSpecification)
  # Transform the stages of this species into a dictionary, for easy access.
  stages = Dict{String, SpeciesStage}()
  for st in c.stages
    stages[st.label] = st
  end

  # Construct the individual type for this species.
  I = individual_type(c.stages, c.fitness)

  # Build the species object.
  Species{I}(stages, c.fitness)
end

"""
Unlike a simple species, a complex species may be composed of numerous
developmental stages, or different views on a particular stage.

For example, in the case of grammatical evolution, one may wish to represent
use different stages to represent the individual as a bit vector, codon
vector, program string, and compiled program.
"""
complex(fitness::FitnessScheme, stages::Vector{SpeciesStage}) =
  ComplexSpeciesSpecification(fitness, stages)

complex(stages::Vector{SpeciesStage}) =
  ComplexSpeciesSpecification(stages)

function complex(spec::Function)
  ss = ComplexSpeciesSpecification()
  spec(ss)
  ss
end
