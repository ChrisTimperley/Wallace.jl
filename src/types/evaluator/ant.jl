load("simple", dirname(@__FILE__))
load("ant/ant", dirname(@__FILE__))
load("../fitness/simple", dirname(@__FILE__))

type AntEvaluator <: SimpleEvaluator
  ant::Ant
  AntEvaluator(ant::Ant) = new(ant)
end

function evaluate!(e::AntEvaluator, s::State, c::Individual)
  while e.ant.moves < e.ant.max_moves && e.ant.score < e.ant.max_score
    execute(get(c.tree), e.ant)
  end
  score = e.ant.score::Int
  reset!(e.ant)
  SimpleFitness{Int}(true, score)
end

register(joinpath(dirname(@__FILE__), "ant.manifest.yml"))
