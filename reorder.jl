legend = [
  "s" => Dict{String, Any}(),
  "s2" => Dict{String, Any}(),
  "x" => ["source" => "m"],
  "m" => ["source" => "s"]
]

srcs = collect(keys(Dict{String, Any}(legend)))

i = 1
while i < length(srcs)
  gt_i = findfirst(srcs) do j
    haskey(legend[srcs[i]], "source") && legend[srcs[i]]["source"] == j
  end
  if gt_i != 0 && gt_i > i
    srcs[gt_i], srcs[i] = srcs[i], srcs[gt_i]
  else
    i += 1
  end
end
 
println(srcs)
