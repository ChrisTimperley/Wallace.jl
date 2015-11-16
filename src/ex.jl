abstract Individual

type Individual{F}
  fitness::F
  stage::
end

type SimpleIndividual <: Individual
    fitness::F
    genome::
end

type Deme
  stages::Vector{Any}
end

# population:
# stages["genome"] = BitVector[]
