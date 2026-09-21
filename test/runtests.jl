using PowerIO
using Test
using JSON3
using Aqua
using Libdl
using Logging
using SHA
using SparseArrays

# The C library under test. Every ccall test skips when no library resolves;
# CI sets `POWERIO_CAPI` to a fresh `powerio-capi` build.
const LIBRARY_AVAILABLE = PowerIO.library_available()
get(ENV, "POWERIO_REQUIRE_LIBRARY", "0") == "1" && !LIBRARY_AVAILABLE && error("A compatible C library is required for this test run")
LIBRARY_AVAILABLE || @info "PowerIO: no compatible libpowerio_capi resolved; ccall tests skip (set POWERIO_CAPI)"

const DATA = joinpath(@__DIR__, "data")
fixture(parts...) = joinpath(DATA, parts...)

@testset "PowerIO" begin
    include("test_release.jl")
    include("test_release_automation.jl")
    include("test_public_api.jl")
    include("test_native_library_boundary.jl")
    include("test_capi_coverage.jl")
    include("test_operations.jl")
    include("test_network.jl")
    include("test_geography.jl")
    include("test_dist.jl")
    include("test_collections.jl")
    include("test_lindist3flow.jl")
    include("test_handle_operations.jl")
    include("test_updates.jl")
    include("test_connectivity.jl")
    include("test_scuc.jl")
    include("test_contingency.jl")
    include("test_geo.jl")
    include("test_matrix.jl")
    include("test_bridges.jl")
    include("test_aqua.jl")
end
