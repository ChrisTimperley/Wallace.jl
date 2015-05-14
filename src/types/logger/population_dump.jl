load("../logger", dirname(@__FILE__))

type PopulationDumpLogger <: Logger
  # The destination directory of the population dumps.
  destination::String

  PopulationDumpLogger() = new()
end

function prepare!(l::PopulationDumpLogger, output::String)
  l.destination = joinpath(output, "population_dumps")
  mkdir(l.destination)
end

# Create a new dump file for the current generation inside
# the destination folder.
function log!(l::PopulationDumpLogger, s::State)
 f = open(joinpath(l.destination, string(s.iterations)), "w")
 
 buffer = ""
 for (i, deme) in enumerate(s.population.demes)
  buffer *= "Deme $(i):\n\n"
  for ind in deme.members
    buffer *= describe(ind) * "\n\n"
  end
 end

 write(f, buffer)
 close(f)
end

register(joinpath(dirname(@__FILE__), "population_dump.manifest.yml"))
