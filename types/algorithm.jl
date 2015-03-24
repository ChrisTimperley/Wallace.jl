abstract Algorithm

run(a::Algorithm) = 
  error("No `run` method defined for this algorithm: $(a).")

register("algorithm", Algorithm)
