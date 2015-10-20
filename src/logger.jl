"""
TODO: Description of logging system.
"""
module logger
  using state

  """
  The base type used by all loggers.
  """
  abstract Logger

  """
  Creates a fresh, empty output directory at the specified location, before
  preparing each of the given loggers for the upcoming run.
  """
  function prepare!(ls::Vector{Logger}, output::AbstractString)
    if isdir(output)
      rm(output; recursive = true)
    end
    mkdir(output)
    for l in ls
      prepare!(l, output)
    end
  end
  prepare!(l::Logger, output::AbstractString) = l

  """
  Safely closes a list of provided loggers.
  """
  close!(ls::Vector{Logger}) = for l in ls; close!(l); end

  """
  Safely closes a given logger.
  """
  close!(l::Logger) = l

  #call!(ls::Vector{Logger}, s::State) = for l in ls; call!(l, s); end
  #call!(l::Logger, s::State) = log!(l, s)

  # Load each of the loggers.
  include("logger/best_individual.jl")
  include("logger/population_dump.jl")
end
