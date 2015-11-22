type EvoAnalyserLogger <: Logger

end

function write_meta_to_log_file(l::EvoAnalyserLogger)
  
end

function log!()

end

"""
Converts a provided collection of individuals into a CSV string, where each
individual is represented by a record within the string.

**Parameters:**

* ``ic::IndividualCollection``, the collection of individuals.
* ``fs::FitnessScheme``, the fitness scheme used by the individuals belonging
  to the collection.
* ``prefix::UTF8String``, the prefix that should be added to each CSV
  record. Used to provide generation and deme numbers. If any information
  is provided in the prefix, it MUST be suffixed by a semi-colon.

**Returns:**

A CSV string, in the form of a UTF-8 string.
"""

function individuals_to_csv(
  ic::IndividualCollection,
  fs::FitnessScheme,
  prefix::UTF8String
)::UTF8String
  # Initialise the CSV row for each individual.
  num = length(ic)
  serialised = UTF8String["$(prefix) $(i)" for i in 1:num]

  # Record the developmental stage for each individual.
  for rep in keys(ic.stages)
    for (i, stage) in enumerate(ic.stages[rep])
      serialised[i] = serialised[i] * "; $(to_s(stage))"
    end
  end

  # Add the fintess values for each individual to the JSON objects,
  # along with their evaluated flag.
  for (i, csv) in enumerate(serialised)
    csv = csv * "; true; " * to_s(fs, ic.fitnesses[i])
  end

  # Glue together the individual CSV entries.
  return join(serialised, "\n")
end

"""
Converts a provided collection of individuals into a list of JSON descriptions.

**Parameters:**

* ``ic::IndividualCollection``, the collection of individuals.
* ``fs::FitnessScheme``, the fitness scheme used by the individuals belonging
  to the collection.
* ``prefix::UTF8String``, the prefix that should be added to each JSON
  description. Used to provide generation and deme numbers. If any information
  is provided in the prefix, it MUST be suffixed by a comma.

**Returns:**

A list of JSON descriptions, implemented as a vector of UTF-8 strings.
"""

# Idea: Could supply a JSON prefix? (generations, deme number, etc).
function individuals_to_json(
  ic::IndividualCollection,
  fs::FitnessScheme,
  prefix::UTF8String
)
  # Find the number of individuals in the provided collection.
  num = length(ic)

  # Create an array to hold the JSON objects for each of the individuals within
  # the provided collection, initialised with the supplied prefix and the
  # individual's position.
  serialised = UTF8String["$(prefix) \"position\": $(i)" for i in 1:num]

  # Add each of the representations used by the individual to the log entries.
  for rep in keys(ic.stages)
    for (i, stage) in enumerate(ic.stages[rep])
      serialised[i] = serialised[i] * ", \"$(rep)\": $(to_json_s(stage))"
    end
  end

  # Add the fitness values for each individual to the JSON objects, along with
  # their evaluated flag.
  for (i, json) in enumerate(serialised)
    json = json * ", \"evaluated\": true, " * to_json(fs, ic.fitnesses[i])
  end

  # Add the opening and closing tags to each JSON object.
  map!(json -> "{" * json * "}", serialised)

  # Return the vector of JSON descriptions.
  return serialised
end
