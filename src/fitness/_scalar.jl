type ScalarFitnessScheme{T <: Number} <: FitnessScheme
  maximise::Bool

  ScalarFitnessScheme(m::Bool) = new(m)
end

"""
The scalar fitness scheme represents the fitness of an individual using a
single scalar value, which is subject to either maximisation or minimisation.

**Properties:**

* `of::Float`, the type used to represent fitness values. Defaults to `Float`.
* `maximise::Bool`, a flag specifying whether the fitness value should be
maximised. Defaults to `true`.
"""
scalar(s::Dict{Any, Any}) =
  scalar(eval(Base.parse(Base.get(s, "of", "Float"))), Base.get(s, "maximise", true))
scalar(maximise::Bool) = scalar(Float, maximise)
scalar() = scalar(Float, true)
scalar(t::Type) = scalar(t, true)
scalar(t::Type, maximise::Bool) =
  ScalarFitnessScheme{t}(maximise)

uses{T}(s::ScalarFitnessScheme{T}) = T
maximise(s::ScalarFitnessScheme) = s.maximise
assign{T}(s::ScalarFitnessScheme{T}, v::T) = v

compare{T <: Number}(s::ScalarFitnessScheme{T}, x::T, y::T) =
  if x > y
    s.maximise ? -1 : 1
  elseif x < y
    s.maximise ? 1 : -1
  else
    0
  end
