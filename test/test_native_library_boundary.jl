using Test

@testset "native library boundary" begin
    @testset "missing explicit library is fail-closed" begin
        missing = joinpath(@__DIR__, "definitely-not-a-powerio-library")
        err = try
            PowerIO.abi_version(missing)
            nothing
        catch e
            e
        end
        @test err isa Exception
        @test PowerIO.library_available() isa Bool
    end

    @testset "library override precedence" begin
        original = PowerIO._SESSION_LIBRARY[]
        try
            sentinel = joinpath(@__DIR__, "synthetic-powerio-capi")
            PowerIO.set_library!(sentinel)
            @test PowerIO._lib() == sentinel
        finally
            PowerIO._SESSION_LIBRARY[] = original
        end
    end

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

    @testset "documentation has no retired callable names" begin
        root = dirname(@__DIR__)
        docs_root = joinpath(root, "docs", "src")
        pages = [joinpath(docs_root, p) for p in readdir(docs_root)
                 if endswith(p, ".md") && !startswith(p, "migration")]
        push!(pages, joinpath(root, "README.md"))

        retired_patterns = (
            r"\bparse_file\(", r"\bparse_text\(", r"\bto_json\(", r"\bfrom_json\(",
            r"\blist_states\(", r"\bexport_state\(", r"\bto_balanced\(",
            r"\bresolve_format\(", r"\bto_arrow\(", r"\bbuild_info\(", r"\bhas_feature\(",
            r"\bn_buses\(", r"\bbuses\(", r"ABI 6",
        )

        for page in pages
            text = read(page, String)
            for pattern in retired_patterns
                @test isnothing(match(pattern, text))
            end
        end
    end
end
