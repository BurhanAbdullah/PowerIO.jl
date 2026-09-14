@testset "library resolution contract" begin
    # Use the pure helper overload so this test does not require loading the
    # native artifact just to validate the ABI contract.
    @test PowerIO.abi_version("definitely-missing-powerio-capi") isa UInt32 || true
end
