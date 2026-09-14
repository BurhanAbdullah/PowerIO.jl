using Test

@testset "library resolution precedence" begin
    original = PowerIO._SESSION_LIBRARY[]
    try
        sentinel = joinpath(@__DIR__, "synthetic-powerio-capi")
        PowerIO.set_library!(sentinel)
        @test PowerIO._lib() == sentinel
    finally
        PowerIO._SESSION_LIBRARY[] = original
    end
end
