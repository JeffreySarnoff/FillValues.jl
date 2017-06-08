using Base.Test
using LOCF

novalue = NaN
a = [1.0, 2.0, 3.0]
b = [1.0, novalue, 3.0]
c = [1.0, 2.0, novalue]
d = [novalue, 2.0, 3.0]

@test locf(a) == a
@test locf(b) == [1.0, 1.0, 3.0]
@test locf(c) == [1.0, 2.0, 2.0]
@test locf(d) == [2.0, 2.0, 3.0]
@test locf(d, true) == [2.0, 2.0, 3.0]
@test isnan(locf(d, false)[1])

novalue = Nullable{Float64}()
a = [Nullable{Float64}(1.0), Nullable{Float64}(2.0), Nullable{Float64}(3.0)]
b = [Nullable{Float64}(1.0), novalue, Nullable{Float64}(3.0)]
c = [Nullable{Float64}(1.0), Nullable{Float64}(2.0), novalue]
d = [novalue, Nullable{Float64}(2.0), Nullable{Float64}(3.0)]

@test all(locf(a) .=== a)
@test all(locf(b) .=== [Nullable{Float64}(1.0), Nullable{Float64}(1.0), Nullable{Float64}(3.0)])
@test all(locf(c) .=== [Nullable{Float64}(1.0), Nullable{Float64}(2.0), Nullable{Float64}(2.0)])
@test all(locf(d) .=== [Nullable{Float64}(2.0), Nullable{Float64}(2.0), Nullable{Float64}(3.0)])
@test !isnull(locf(d, true)[1])
@test isnull(locf(d, false)[1])

