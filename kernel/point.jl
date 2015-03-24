#import JSON
#import DataStructures.OrderedDict
#
#dt = JSON.parsefile("../scripts/a.json"; ordered = true)
#
#is_ins(::Any) = false
#is_ins(s::OrderedDict{String, Any}) = collect(keys(s)) == ["\$"]
#
#match_ins(s::OrderedDict{String, Any}, loc::String) =
#  match_ins(s, String[ss for ss in split(loc, ".")])
#match_ins(s::OrderedDict{String, Any}, loc::Vector{String}) =
#  length(loc) == 1 ? s[loc[1]] : match_ins(s[shift!(loc)], loc)
#match_ins(s::Vector{Any}, loc::Vector{String}) =
#  length(loc) == 1 ? s[parseint(loc[1])] : match_ins(s[parseint(shift!(loc))], loc)
#
#inj_ins!(s::OrderedDict{String, Any}) = inj_ins!(s, s)
#inj_ins!(s::OrderedDict{String, Any}, ss::Any) = return
#function inj_ins!(s::OrderedDict{String, Any}, ss::OrderedDict{String, Any})
#  for (k,v) in ss
#    is_ins(v) ? ss[k] = match_ins(s, v["\$"]) : inj_ins!(s, v)
#  end
#end
#function inj_ins!(s::OrderedDict{String, Any}, ss::Vector{Any})
#  for (i,v) in enumerate(ss)
#    is_ins(v) ? ss[i] = match_ins(s, v["\$"]) : inj_ins!(s, v)
#  end
#end
#
#inj_ins!(dt)
#println(dt)
#println(match_ins(dt, "x.a.2"))
