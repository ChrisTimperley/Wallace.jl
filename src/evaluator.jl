"""
Evaluators are used to assess the success or performance of candidate solutions
on some predetermined set of search objectives.

Unlike most other evolutionary computation frameworks, evaluators do not
immediately calculate the fitness values for individuals. Instead, the raw
objective scores for a given set of individuals is first calculated and
stored, before the fitness values for each individual are computed according
to those values according to some fitness scheme.

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

do_nothing(c::Criterion) = "hello"

# Load each of the evaluators.
include("evaluator/_simple.jl")
#include("evaluator/_tsp.jl")
#include("evaluator/_regression.jl")
#include("evaluator/_multiplexer.jl")
#include("evaluator/_ant.jl")
end
