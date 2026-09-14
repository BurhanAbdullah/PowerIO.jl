using Test

@testset "handle library isolation" begin
    struct DummyHandle <: PowerIO.Handle
        lib::String
    end

    h1 = DummyHandle("libpowerio_capi-a")
    h2 = DummyHandle("libpowerio_capi-a")
    h3 = DummyHandle("libpowerio_capi-b")

    @test PowerIO._require_library(h1.lib, h2) === nothing
    @test_throws ArgumentError PowerIO._require_library(h1.lib, h3)
end
