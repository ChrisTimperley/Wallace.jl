require("Wallace.jl")
using Wallace

def = algorithm.genetic() do
  println("hello!")
end

alg = Wallace.compose!(def)
