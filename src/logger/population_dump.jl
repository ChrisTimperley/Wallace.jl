type PopulationDumpLogger <: Logger
  # The destination directory of the population dumps.
  destination::AbstractString

  PopulationDumpLogger() = new()
end

"""
The population dump logger writes the state of each member of the population
to a single log file, including their fitness and their representation(s), at
the end of each generation.
"""
population_dump() = PopulationDumpLogger()

function prepare!(l::PopulationDumpLogger, output::AbstractString)
  l.destination = joinpath(output, "population_dumps")
  mkdir(l.destination)
end

"""
Creates a new dump file for the current generation within the destination
folder specified by the logger.
"""
#function log!(l::PopulationDumpLogger, s::State)
# f = open(joinpath(l.destination, string(s.iterations)), "w")
# buffer = ""
#
# for (i, deme) in enumerate(s.population.demes)
#  buffer *= "Deme $(i):\n\n"
#  for ind in deme.members
#    buffer *= describe(ind) * "\n\n"
#  end
# end
#
# write(f, buffer)
# close(f)
#end
