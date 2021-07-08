using StreamStats
using Test

@testset "StreamStats.jl" begin
    test_data = Vector{UInt8}("TestInlyseTestRandom320940923u4kkljsdflkajsdf")
    @test StreamStats.compute_shanon(test_data) == 2.99
    # @test StreamStats.compute_monte_carlo()
    # @test StreamStats.chi_squared()
end
