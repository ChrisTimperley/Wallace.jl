load("../../fitness", dirname(@__FILE__))

type ScalarFitnessScheme{T <: Number} <: FitnessScheme
  maximise::Bool

  ScalarFitnessScheme(m::Bool) = new(m)
end

uses{T}(s::ScalarFitnessScheme{T}) = T

fitness{T}(s::ScalarFitnessScheme{T}, v::T) = T

compare{T <: Number}(s::ScalarFitnessScheme{T}, x::T, y::T) =
  if x > y
    s.maximise ? -1 : 1
  elseif x < y
    s.maximise ? 1 : -1
  else
    0
  end

register(joinpath(dirname(@__FILE__), "scalar.manifest.yml"))
