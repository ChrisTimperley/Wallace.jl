type KozaInput
  label::String
  ty::String

  KozaInput(def::String) = new(def[1:Base.search(def, ':')-1],
    def[Base.last(Base.search(def, "::"))+1:end])
end

compile(il::Vector{KozaInput}) = join(["$(i.label)::$(i.ty)" for i in il], ",")
