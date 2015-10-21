#abstract BreederStage
#
#type SelectionBreederStage <: BreederStage
#
#end
#
#type VariationBreederStage <: BreederStage
#
#end
#
#function execute{I <: Individual}(
#  s::SelectionBreederStage, from::Vector{I}, to::Vector{I}, num::Integer
#)
#  
#  # How many individuals do I need to generate?
#
#  # How many calls does that translate to?
#
#end
#
#execute{I <: Individual}(
#  s::SelectionBreederStage, from::Vector{I}, to::Vector{I}, num::Integer, calls::Integer
#) = for i in 1:calls
#  execute(s, from, to, num, calls, i)
#end
#
#execute{I <: Individual}(
#  s::SelectionBreederStage, from::Vector{I}, to::Vector{I}, num::Integer, calls::Integer, i::Integer
#) = operate!(s.operator, from[in_start:in_end], to[out_start:out_end])
#
# Happy with this
#operate!(op::TournamentSelection, num::Integer, inputs::Vector{I}, outputs::Vector{I}) = for i in 1:num
#  outputs[i] = best(sample(inputs, op.size; replace = true))
#end
#
# Number of calls required to produce a given number of individuals.
#calls_required(::TournamentSelection, n::Integer) = 1
#inputs_required(::TournamentSelection, n::Integer) = n
#
#function operate!(op::GaussianMutation, num::Integer, inputs::Vector{I}, outputs::Vector{I})
#  # Copy the individual across.
#  outputs[1] = inputs[1]
#
#  # Retrieve the genome.
#  genome = accessor(outputs[1])
#  for i in 1:length(genome) # Better to pre-compute size if we can.
#    rand() <= op.rate && genome[i] = clamp!(op, noise!(op, genome[i]))
#  end
#end
#
# What if we can't produce an individual for some reason?
