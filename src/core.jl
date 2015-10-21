"""
This module is used to define several core, abstract types, in order to keep
compilation simple, and to avoid any circular dependencies between modules.
"""
module core
  export Individual, Operator, Variation

"""
The base type used by all individuals.
"""
abstract Individual

"""
The base type used by all search operators.
"""
abstract Operator

"""
The base type used by all variation operators.
"""
abstract Variation <: Operator

end
