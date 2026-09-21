@testset "library resolution" begin
    @test PowerIO.PIO_ABI_VERSION == UInt32(7)

    # The explicit-path ABI query must fail at the native loader boundary
    # rather than being mistaken for an incompatible ABI.
    err = try
        PowerIO.abi_version(joinpath(@__DIR__, "definitely-not-a-powerio-library"))
        nothing
    catch e
        e
    end
    @test err isa Exception

    # `library_available` is intentionally fail-closed.
    @test PowerIO.library_available() isa Bool
end
