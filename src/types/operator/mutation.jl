# encoding: utf-8
load("variation",  dirname(@__FILE__))

abstract Mutation <: Variation

# Register this type.
register("mutation", Mutation)
