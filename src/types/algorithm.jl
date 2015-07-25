abstract Algorithm

export run!
run!(a::Algorithm) = 
  error("No `run!` method defined for this algorithm: $(a).")

register(joinpath(dirname(@__FILE__), "algorithm.manifest.yml"))
