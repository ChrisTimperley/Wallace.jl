type ComplexSpeciesDefinition <: SpeciesDefinition
  fitness::FitnessScheme
  stages::Vector{SpeciesStageDefinition}

  ComplexSpeciesDefinition() =
    new(fitness.scalar())
  ComplexSpeciesDefinition(st::Vector{SpeciesStageDefinition}) =
    new(fitness.scalar(), st)
  ComplexSpeciesDefinition(f::FitnessScheme, st::Vector{SpeciesStageDefinition}) =
    new(f, st)
end

"""
Composes a complex species from a provided definition.
"""
function compose!(c::ComplexSpeciesDefinition)
  # Compose each of the stages within this species.
  stages = Dict{String, SpeciesStage}()
  for st in c.stages
    stages[st.label] = compose!(st)
  end

  # Construct the individual type for this species.
  I = individual_type(collect(values(stages)), c.fitness)
  
  println("Built individual type.")

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
complex(fitness::FitnessScheme, stages::Vector{SpeciesStageDefinition}) =
  ComplexSpeciesSpecification(fitness, stages)

complex(stages::Vector{SpeciesStageDefinition}) =
  ComplexSpeciesDefinition(stages)

function complex(spec::Function)
  ss = ComplexSpeciesDefinition()
  spec(ss)
  ss
end
