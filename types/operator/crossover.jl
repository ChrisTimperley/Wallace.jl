load("variation",  dirname(@__FILE__))

abstract Crossover <: Variation

register("crossover", Crossover)
