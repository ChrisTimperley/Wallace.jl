# encoding: utf-8
factory("algorithm/evolutionary_algorithm", parent: "something") do f
  attribute(f, "evaluator", t("evaluator"))
  attribute(f, "replacer", t("replacer"))

  has_many(f, "termination_conditions", "termination_condition", t("criterion"))
  has_many(f, "loggers", "logger", t("logger"))
end

factory("deme") do f
  attribute(f, "capacity" , Integer, 100)
  attribute(f, "offspring", Integer)
  attribute(f, "species"  , t("species"))
  attribute(f, "breeder"  , t("breeder"))
end

factory("species") do f
  has_many(f, "stages", "stage", t("stage"))
end

factory("breeder/fast") do f
  has_many(f, "operators", "operator", t(""))
end

algorithm "max_ones" extends "evolutionary_algorithm"

  # Termination conditions.
  termination_condition "evaluation_limit", limit: 1000
  termination_condition "iterations_limit", limit: 100000

  # Population is an instance parameter.
  deme capacity: 3000
    species
      stage "bit_string"
        representation "bit_vector", length: 800

      stage "int_string", from: "bit_string"
        representation "int_vector", length: 100

      stage "derivation", from: "int_string"
        representation "grammar_derivation", max_wraps: 5
          rule "e",   ["({e}{op}{e})", "{e}{op}{e}", "{v}"]
          rule "op",  ["+", "-", "/", "*"]
          rule "v",   ["x", "y"]

    # It would be good if we could pass a breeder instead!
    breeder "fast"
      selector "tournament", name: "selector", size: 5
      operator "uniform_mutation", name: "mutation", rate: 0.01, source: "selector"
      operator "one_point_crossover", name: "crossover", rate: 0.7, source: "mutation"

  # Replacement scheme.
  replacer "generational", elitism: 10

  # Logging mechanisms.
  logger "fitness_dump", output: "output/"
  logger "best_individual", output: "output/"

  # Evaluator.
  evaluator "simple", threads: 8 do
    #SimpleFitness(count(individual["int_string"]))
    @make "fitness/simple", count(individual["int_string"])
  end


algorithm "max_ones" do s

  add(s, "termination_condition", make("criterion/evaluation_limit"; limit: 1000))
  add(s, "termination_condition", make("criterion/iterations_limit"; limit: 1000))

  add(s, "deme"; make("deme"; capacity: 3000) do s1
    set(s1, "species", make("species") do s2
      add(s2, "stage", "bit_string", make("stage") do s3
        set(s3, "representation", make("representation/bit_vector"; length: 800))
      end)

      add(s2, "stage", "int_string", make("stage") do s3
        set(s3, "representation", make("representation/int_vector"; length: 100))
      end)

      add(s2, "stage", "derivation", make("stage") do s3
        set(s3, "representation", make("representation/grammar_derivation"; max_wraps: 5) do s4
          add(s4, "rule", "e", ["({e}{op}{e})", "{e}{op}{e}", "{v}"])
        end)
      end)
    end)

  end)

end

algorithm do

  # Termination conditions.
  s.termination_conditions["evalutions"] = i("criterion/evaluation_limit"; limit = 50000)
  s.termination_conditions["iterations"] = i("criterion/iterations_limit"; limit = 1000)

  # Population setup.
  push!(s.demes, i("deme"; capacity = 1000) do deme

    # Species of this deme.
    deme.species = i("species") do species
      
      species.stages["bit_string"] = i("stage") do stage
        s.representation = i("representation/bit_vector"; length = 800)
      end

      species.stages["int_string"] = i("stage") do stage
        s.representation = i("representation/int_vector"; length = 100)
      end

      species.stages["derivation"] = i("stage") do stage
        s.representation = i("representation/grammar_derivation"; max_wraps = 5) do r
          r.rules["e"] = ["({e}{op}{e})", "{e}{op}{e}", "{v}"]
          r.rules["op"] = ["+", "-", "*", "/"]
        end
      end
    end

    breeder do b
      
    end

    # Breeding operations.
    deme.breeder = i("breeder/fast") do b
      b.operators["tournament"] = i("breeder/fast:source/selection") do s
        s.operator = i("selector/tournament"; size = 5)
      end

      b.operators["one_point_crossover"] = i("breeder/fast:source/variation") do s
        s.source = b.operators["tournament"]
        s.operator = i("crossover/one_point"; rate = 0.7)
      end

      b.operators["uniform_mutation"] = i("breeder/fast:source/variation") do s
        s.source = b.operators["one_point_crossover"]
        s.operator = i("mutation/uniform"; rate = 0.01)
      end
    end
  end)

end

t("individual") do
  
  # Compile each stage into a property.
  property(def, stage.name, stage.type)

end

# Factories and Type Factories.