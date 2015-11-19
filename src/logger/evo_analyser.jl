type EvoAnalyserLogger <: Logger

end

function write_meta_to_log_file(l::EvoAnalyserLogger)
  
end

function log!()

end

"""
Converts a provided collection of individuals into a list of JSON descriptions.

**Parameters:**

* ``ic::IndividualCollection``, the collection of individuals.
* ``fs::FitnessScheme``, the fitness scheme used by the individuals belonging
  to the collection.

**Returns:**

A list of JSON descriptions, implemented as a vector of UTF-8 strings.
"""
function individuals_to_log_entries(
  ic::IndividualCollection,
  fs::FitnessScheme
)
  # Find the number of individuals in the provided collection.
  num = length(ic)

  # Create an array to hold the JSON objects for each of the individuals within
  # the provided collection, initialised with the current generation number and
  # the individual's position.
  serialised = UTF8String["\"generation\": $(gen), \"position\": $(i)" for i in 1:num]

  # Add each of the representations used by the individual to the log entries.
  for rep in keys(ic.stages)
    for (i, stage) in enumerate(ic.stages[rep])
      serialised[i] = serialised[i] * ", \"$(rep)\": $(to_json_s(stage))"
    end
  end

  # Add the evaluated flag to each individual.
  map!(json -> json * ", \"evaluated\": true", serialised)

  # Add the fitness values for each individual to the JSON objects, along with
  # their evaluated flag.
  for (i, json) in enumerate(serialised)
    json = json * ", \"evaluated\": true, " * to_json(fs, ic.fitnesses[i])
  end

  # Add the opening and closing tags to each JSON object.
  map!(json -> "{" * json * "}")

  # Return the vector of JSON descriptions.
  return json
end

function write_entry_to_log_file(
  l::EvoAnalyserLogger,
  generation::Int,
  position::Int,
  deme::Int,
  fitness::F
)

end
