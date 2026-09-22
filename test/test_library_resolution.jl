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

    # `library_available` is intentionally fail-closed and can also probe an
    # explicit candidate without changing the active resolution.
    missing = joinpath(@__DIR__, "definitely-not-a-powerio-library")
    @test PowerIO.library_available(missing) === false
    @test PowerIO.library_available() isa Bool

    if LIBRARY_AVAILABLE
        lib = PowerIO._checked_lib()
        @test PowerIO.library_available(lib) === true
        @test PowerIO._checked_lib() == lib
    end
end
