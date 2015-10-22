"""
Complex populations may consist of multiple demes, where all members of a given
deme belong to the same species, but each deme may use a different species.

**Properties:**

*`demes::Vector{DemeDefinition}`, an ordered list containing specifications
  for each of the demes within this population.
"""
complex(demes::Vector{_deme_.DemeDefinition}) =
  Population(Deme[_deme_.compose!(d) for d in demes]) 
