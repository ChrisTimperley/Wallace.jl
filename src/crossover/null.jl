type NullCrossover <: Crossover
  stage::AbstractString
  rep::Representation

  NullCrossover(stage::AbstractString, rep::Representation) =
    new(stage, rep)
end

"""
Used to provide a definition for a null crossover operation.
"""
type NullCrossoverDefinition <: CrossoverDefinition
  stage::AbstractString
end

"""
Composes a null crossover operator from a provided definition, for a given
species.
"""
function compose!(c::NullCrossoverDefinition, sp::Species)
  c.stage = c.stage == "" ? genotype(sp).label : c.stage
  r = sp.stages[c.stage].representation
  NullCrossover(c.stage, r)
end

"""
Null crossover operators accept a pair of chromosomes and return the same pair
of chromosomes untouched. Useful for debugging purposes.

**Positional Arguments:**

* `stage::AbstractString`, the name of the stage that this operator should use.
  Defaults to the genotype if no stage is specified.
"""
null() = null("")
null(stage::AbstractString) = NullCrossoverDefinition(stage)

"""
Performs a null crossover operation on two provided chromosomes, returning the
same chromosomes unchanged.
"""
operate!{T}(::NullCrossover, outputs::Vector{IndividualStage{T}}, x::T, y::T) =
  outputs
