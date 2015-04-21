# Store the path to the example scripts.
EXAMPLES_PATH = joinpath(dirname(@__FILE__), "../../examples")

# Composes an instance of a given example problem.
function example(name::String)
  path = joinpath(EXAMPLES_PATH, "$(name).cfg")

  # Throw an error if the requested example doesn't exist.
  if !isfile(path)
    fail("Failed to locate specified example within examples directory: $(name).") 
  end
  
  # Otherwise load and compose the configuration file for the given example.
  return compose(path)
end
export example

# Returns a list of all available example problems.
examples() = map!(f -> f[1:end-4], 
  filter!(f -> isfile(joinpath(EXAMPLES_PATH, f)) && endswith(f, ".cfg"), readdir(EXAMPLES_PATH)))
export examples
