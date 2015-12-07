"""
Provides a definition for a null mutation operator.
"""
type NullMutationDefinition <: MutationDefinition
  stage::AbstractString
end

type NullMutation <: Mutation
  stage::AbstractString
  representation::Representation
end

"""
Composes a null mutation operator from its definition.
"""
function compose!(d::NullMutationDefinition, sp::Species)
  d.stage = d.stage == "" ? genotype(sp).label : d.stage
  NullpMutation(d.stage, sp.stages[d.stage].representation)
end

"""
The null mutation operator accepts a single chromosome as its input and does
absolutely nothing to it. Useful for debugging purposes.

**Parameter:**

* `stage::AbstractString`, the name of the stage that this null operator should
  be applied to. If omitted, this operator will act upon the genotype.
"""
null() = null("")
null(stage::AbstractString) = null(stage)

"""
The null mutation operator accepts an input and does nothing with it.
"""
mutate!(::NullMutation, i::Any) = return i
