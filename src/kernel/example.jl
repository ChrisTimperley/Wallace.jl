# Composes an instance of a given example problem.
function example(name::String)
  path = joinpath(dirname(@__FILE__), "../../examples/$(name).cfg")

  # Throw an error if the requested example doesn't exist.
  if !isfile(path)
    fail("Failed to locate specified example within examples directory: $(name).") 
  end
  
  # Otherwise load and compose the configuration file for the given example.
  return compose(path)
end
