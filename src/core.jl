"""
This module is used to define several core, abstract types, in order to keep
compilation simple, and to avoid any circular dependencies between modules.
"""
module core
export Individual, Operator, OperatorDefinition

"""
The base type used by all individuals.
"""
abstract Individual

type Individual{F}
  id::Int # need to be able to locate.
  fitness::F
end

"get(deme, ind, 'genome')" "get('genome')"

"""
The base type used by all search operators.
"""
abstract Operator

"""
The base type used by all search operator definitions.
"""
abstract OperatorDefinition
end
