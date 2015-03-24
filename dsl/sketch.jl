# encoding: utf-8

register("selection.tournament", TournamentSelection)

unfold("selection.tournament")

algorithm :max_ones {
  extends :evolutionary_algorithm
  

}

partial("breeder.fast") do t
  extend(t, "")

  attribute(t, "size::Int64")
  attribute(t, "pick_best::Bool")

  # constructors
end

# Instance description.
Wallace.i("algorithm/evolutionary_algorithm") do t

  t.replacement = Wallace.i("replacer/generational") do t
    t.elitism = 0
  end

  t.representation = Wallace.i("representation/int_vector") do t
    t.length = 200
    t.min = 0
    t.max = 1000
  end

  t.breeder = Wallace.i("breeder/fast") do t
    Wallace.i("selection/tournament", {:size => 5}))
    Wallace.i("variation/crossover/one_point", {:rate => 0.7})
    Wallace.i("variation/mutation/uniform", {:rate => 0.01})
  end
  # calls post_build!(t.breeder)

  evaluator :simple

end
