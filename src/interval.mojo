from math.limit import inf as math_inf

alias inf = math_inf[DType.float64]()


struct Interval:
    var min: Float64
    var max: Float64

    fn __init__(inout self, min_val: Float64, max_val: Float64) -> None:
        self.min = min_val
        self.max = max_val

    fn size(self) -> Float64:
        return self.max - self.min

    fn contains(self, x: Float64) -> Bool:
        return self.min <= x and x <= self.max

    fn surrounds(self, x: Float64) -> Bool:
        return self.min < x and x < self.max


alias IntervalEmpty = Interval(inf, -inf)
alias IntervalUniverse = Interval(-inf, inf)
