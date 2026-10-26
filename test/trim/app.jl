# The PowerIO path a `juliac --trim=safe` image can carry: a typed parse and the
# ExaModelsPower bridge with the element type given positionally. Built and run
# by build.jl; prints the table sizes so the run can be checked.
using PowerIO

function (@main)(args::Vector{String})::Cint
    m = parse(BalancedNetwork, args[1])
    data = to_powerdata(m.value, Float64; zero_impedance = :open)
    sizes = (length(data.bus), length(data.gen), length(data.branch), length(data.arc), length(data.storage))
    println(Core.stdout, join(map(string, sizes), ' ') * " " * string(data.baseMVA))
    return 0
end
