using Base.Test
using LOCF

a = [1.0, 2.0, 3.0]
b = [1.0, NaN, 3.0]
c = [1.0, 2.0, NaN]
d = [NaN, 2.0, 3.0]

@test locf(a) == a
@test locf(b) == [1.0, 1.0, 3.0]
@test locf(c) == [1.0, 2.0, 2.0]
@test locf(d) == [2.0, 2.0, 2.0]
@test locf(d, true) == [2.0, 2.0, 3.0]
@test locf(d, false) == [NaN, 2.0, 3.0]
