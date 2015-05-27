load("../fitness", dirname(@__FILE__))

type ScalarFitnessScheme{T} <: FitnessScheme
  maximise::Bool

  ScalarFitnessScheme(m::Bool) = new(m)
end

compare{T}(s::ScalarFitnessScheme{T}, x::T, y::T) =
  if x > y
    s.maximise ? -1 : 1
  elseif x < y
    s.maximise ? 1 : -1
  else
    0
  end
