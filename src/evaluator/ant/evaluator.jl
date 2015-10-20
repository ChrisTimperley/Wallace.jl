load("../simple/simple",      dirname(@__FILE__))
load("ant",                   dirname(@__FILE__))
load("../../fitness/simple",  dirname(@__FILE__))

type AntEvaluator <: SimpleEvaluator
  ant::Ant
  AntEvaluator(ant::Ant) = new(ant)
end

function evaluate!(e::AntEvaluator, s::State, sc::FitnessScheme, c::Individual)
  while e.ant.moves < e.ant.max_moves && e.ant.score < e.ant.max_score
    execute(get(c.genome), e.ant)
  end
  score = e.ant.score
  reset!(e.ant)
  fitness(sc, score)
end

register(joinpath(dirname(@__FILE__), "manifest.yml"))
