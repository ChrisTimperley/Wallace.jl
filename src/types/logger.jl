load("state", dirname(@__FILE__))

abstract Logger

# Creates a fresh empty output directory at the provided location,
# and prepares each of the loggers for the upcoming run.
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

close!(ls::Vector{Logger}) = for l in ls; close!(l); end
close!(l::Logger) = l

call!(ls::Vector{Logger}, s::State) = for l in ls; call!(l, s); end
call!(l::Logger, s::State) = log!(l, s)

register(joinpath(dirname(@__FILE__), "logger.manifest.yml"))
