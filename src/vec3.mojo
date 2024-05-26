import math
from math.math import clamp


@register_passable
struct Vec3:
    var data: SIMD[DType.float64, 4]

    @always_inline
    fn x(self) -> Float64:
        """
        Get value of "x" at index 0.
        """
        return self.data[0]

    @always_inline
    fn y(self) -> Float64:
        """
        Get value of "y" at index 1.
        """
        return self.data[1]

    @always_inline
    fn z(self) -> Float64:
        """
        Get value of "z" at index 2.
        """
        return self.data[2]

    @always_inline
    fn __init__(
        x: Float64 = 0.0,
        y: Float64 = 0.0,
        z: Float64 = 0.0,
        w: Float64 = 0.0,
    ) -> Self:
        """
        Init a Vec3 struct.
        We use a SIMD width of 4 because in mojo it is required to be a power of 2.
        The argument w is never used.

        Args:
            x: Some float that can represent either a positon or an RGB value.
            y: Some float that can represent either a positon or an RGB value.
            z: Some float that can represent either a positon or an RGB value.
            w: Some float that can represent either a position or an RGB value.
        """
        return Vec3 {data: SIMD[DType.float64, 4](x, y, z, w)}

    @always_inline
    fn __init__(vec: SIMD[DType.float64, 4]) -> Self:
        """
        Init a Vec3 struct.

        Args:
            vec: SIMD float64 of size 4 that represents either a position or rgb colour.
                 Note that the argument "w" is unused and is simply there to satisfy Mojo's
                 requirement of SIMD width to be powers of 2.
        """
        return Vec3 {data: vec}

    @always_inline
    fn __copyinit__(existing: Vec3) -> Self:
        """
        Copy data from an existing Vec3 to self.
        """
        return existing.data

    @always_inline
    fn __neg__(self) -> Vec3:
        """
        Negate self.
        """
        return Vec3(-1 * self.data)

    @always_inline
    fn __sub__(self, other: Vec3) -> Vec3:
        """
        Subtract other from self.
        """
        return Vec3(self.data - other.data)

    @always_inline
    fn __sub__(self, other: Float64) -> Vec3:
        """
        Subtract other from self.
        """
        return Vec3(self.data - other)

    @always_inline
    fn __add__(self, other: Vec3) -> Vec3:
        """
        Add self to other.
        """
        return Vec3(self.data + other.data)

    @always_inline
    fn __add__(self, other: Float64) -> Vec3:
        """
        Add self to other.
        """
        return Vec3(self.data + other)

    @always_inline
    fn __mul__(self, other: Vec3) -> Vec3:
        """
        Multiply self with other.
        """
        return Vec3(self.data * other.data)

    @always_inline
    fn __mul__(self, other: Float64) -> Vec3:
        """
        Multiply self with other.
        """
        return Vec3(self.data * other)

    @always_inline
    fn __truediv__(self, other: Float64) -> Vec3:
        """
        Divide self by other.
        """
        return Vec3(self.data / other)

    @always_inline
    fn length_squared(self) -> Float64:
        """
        Return the squared length of the vector.
        """
        return (self.data**2).reduce_add()

    @always_inline
    fn length(self) -> Float64:
        """
        Return the length of a vector.
        """
        return self.length_squared() ** 0.5

    @always_inline
    fn __str__(self) -> String:
        """
        Print vector values.
        """
        var str: String = (
            " x [0]: "
            + String(self.data[0])
            + " y [1]: "
            + String(self.data[1])
            + " z [2]: "
            + String(self.data[2])
        )
        return str

    @always_inline
    fn unit_vector(self) -> Vec3:
        """
        Return the unit vector of self.
        """
        return self.data / self.length()

    @always_inline
    fn __getitem__(self, index: Int) -> Float64:
        """
        Get item at a specific index.
        """
        return self.data[index]

    @always_inline
    fn clamp(self, min_val: Float64, max_val: Float64) -> Vec3:
        return clamp[DType.float64, 4](self.data, min_val, max_val)


@always_inline
fn dot(vec1: Vec3, vec2: Vec3) -> Float64:
    """
    Compute the dot product between a self and other.
    """
    return (vec1.data * vec2.data).reduce_add()


@always_inline
fn cross(vec1: Vec3, vec2: Vec3) -> Vec3:
    """
    Compute the cross product between self and other.
    """
    return Vec3(
        (vec1.data.shuffle[1, 2, 0, 3]() * vec2.data.shuffle[2, 0, 1, 3]())
        - (vec1.data.shuffle[2, 0, 1, 3]() * vec2.data.shuffle[1, 2, 0, 3]())
    )


# alias for point
alias Point3 = Vec3
