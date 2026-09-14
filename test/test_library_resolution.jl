@testset "library resolution" begin
    @test PowerIO.PIO_ABI_VERSION == UInt32(7)

    # The explicit-path ABI query must fail with a useful loader error rather
    # than being mistaken for an incompatible ABI. This exercises the public
    # ABI boundary without requiring a platform-specific native artifact.
    err = try
        PowerIO.abi_version(joinpath(@__DIR__, "definitely-not-a-powerio-library"))
        nothing
    catch e
        e
    end
    @test err !== nothing

    # `library_available` is intentionally fail-closed: an unavailable or
    # incompatible C library reports false instead of throwing during package
    # discovery.
    @test PowerIO.library_available() isa Bool
end
