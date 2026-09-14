using Test

@testset "public API hardening" begin
    root = dirname(@__DIR__)
    docs_root = joinpath(root, "docs", "src")
    pages = [joinpath(docs_root, p) for p in readdir(docs_root)
             if endswith(p, ".md") && !startswith(p, "migration")]
    push!(pages, joinpath(root, "README.md"))

    # Retired API names must not be documented as callable operations.
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

    # Source files should remain plain ASCII where the project explicitly
    # guards against typographic punctuation in generated/documentation text.
    for src in readdir(joinpath(root, "src"); join=true)
        @test !occursin("—", read(src, String))
    end
end
