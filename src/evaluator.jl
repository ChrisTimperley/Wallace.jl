"""
Evaluators are used to assess the success or performance of candidate solutions
on some predetermined set of search objectives.

Unlike most other evolutionary computation frameworks, evaluators do not
immediately calculate the fitness values for individuals. Instead, the raw
objective scores for a given set of individuals is first calculated and
stored, before the fitness values for each individual are computed using
those values according to some fitness scheme.

This difference in treatment makes implementing dynamic problems, co-evolution,
diversity promotion techniques, multi-objective problems, and fuzzy evaluation
much easier!
"""
module evaluator
importall common
using criterion, state, core, utility, fitness, population, _deme_
export Evaluator, EvaluatorDefinition, evaluate!, call

"""
The base type used by all evaluators.
"""
abstract Evaluator

"""
The base type used by all evaluator definitions.
"""
abstract EvaluatorDefinition

# As of Julia 0.5, this method is given priority over its specialised
# forms. I expect this pattern to have affected a few things.
#"""
#Evaluates a given phenome using a provided fitness scheme, according to a
#specified evaluation method. This function should be implemented by each
#evaluator.
#"""
#evaluate!(ev::Evaluator, ::FitnessScheme, ::Any) =
#  error("Unimplemented evaluate!(::Evaluator, ::FitnessScheme, phenome) for evaluator: $(typeof(ev)).")

"""
Evaluates all unevaluated individuals within a provided deme according to
a provided evaluation method.
"""
function evaluate!(ev::Evaluator, s::State, d::Deme)
  for (id, phenome) in enumerate(d.offspring.stages[ev.stage])
    d.offspring.fitnesses[id] = evaluate!(ev, d.species.fitness, get(phenome))
  end
  s.evaluations += length(d.offspring.stages[ev.stage])
end

"""
Evaluates all unevaluated individuals contained within a given state according
to a provided evaluation method..
"""
evaluate!(ev::Evaluator, s::State) =
  for deme in s.population.demes; evaluate!(ev, s, deme); end

# Load each of the evaluators.
include("evaluator/_simple.jl")
include("evaluator/_tsp.jl")
include("evaluator/_regression.jl")
#include("evaluator/_multiplexer.jl")
#include("evaluator/_ant.jl")
end
