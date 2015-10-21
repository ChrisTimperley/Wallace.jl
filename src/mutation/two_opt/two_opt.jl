load("../../mutation", dirname(@__FILE__))

type TwoOptMutation <: Mutation
  size::Integer
  max_attempts::Integer

  TwoOptMutation(r::Representation) = new(r.size)
end

num_inputs(o::TwoOptMutation) = 1
num_outputs(o::TwoOptMutation) = 1

function operate!{T}(o::TwoOptMutation,
  inputs::Vector{IndividualStage{Vector{T}}})
  
  attempts = 0
  solution = input[1]
  fitness = # this is a bit of a problem. 

  while (attempts < o.max_attempts)

    for i = 1:size
      for j = (i + 1):size
        swap(i, j)

      end
    end

    adjusted_fitness = ##

    ##
    if improves(adjusted_fitness, best_fitness)
      attempts = 0
      solution = adjusted
      best_fitness = adjusted_fitness
    else
      attempts += 1
    end
  end

end

register(joinpath(dirname(@__FILE__), "manifest.yml"))
