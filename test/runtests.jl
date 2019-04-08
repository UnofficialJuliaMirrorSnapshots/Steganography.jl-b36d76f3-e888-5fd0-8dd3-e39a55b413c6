
include("../src/Steganography.jl")
VERSION > v"0.7-" ? using Test : using Base.Test

@testset "steganography" begin
    U = read("reliance.txt")
    n = length(U)
    @testset "$S in $T" for S in [UInt8], T in [Int32, Int64, UInt32, UInt64, 
        Float16, Float32, Float64]
        A = rand(T, n)
        for j in 1:n
            r = Steganography.setlast8(A[j], U[j])
            s = Steganography.setlastbits(A[j], U[j], UInt8(8))
            u = Steganography.setlast7(A[j], U[j])
            v = Steganography.setlastbits(A[j], U[j], UInt8(7))
            @test r == s
            @test u == v
            @test Steganography.getlast8(u) == Steganography.getlastbits(u, UInt8(8))
            @test Steganography.getlast7(u) == Steganography.getlastbits(u, UInt8(7))
            @test U[j] == Steganography.getlast7(u)
            @test U[j] == Steganography.getlast8(r)
        end
        A = rand(T, n + 2)
        B = Steganography.embed(A, U)
        V = Steganography.extract(B)
        @test U == V
    end
    @testset "$S in $T" for S in [UInt8], T in [Complex32, Complex64, Complex128]
        A = rand(T, n + 2)
        B = Steganography.embed(A, U)
        V = Steganography.extract(B)
        @test U == V
    end
end
