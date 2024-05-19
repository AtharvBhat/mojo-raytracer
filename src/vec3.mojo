import math


struct Vec3:
    var data: SIMD[DType.float64, 4]

    @always_inline
    fn __init__(
        inout self,
        x: Float64 = 0.0,
        y: Float64 = 0.0,
        z: Float64 = 0.0,
        w: Float64 = 0.0,
    ) -> None:
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
        self.data = SIMD[DType.float64, 4](x, y, z, w)

    @always_inline
    fn __init__(inout self, vec: SIMD[DType.float64, 4]) -> None:
        """
        Init a Vec3 struct.

        Args:
            vec: SIMD float64 of size 4 that represents either a position or rgb colour.
                 Note that the argument "w" is unused and is simply there to satisfy Mojo's
                 requirement of SIMD width to be powers of 2.
        """
        self.data = vec

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
    fn __div__(self, other: Float64) -> Vec3:
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
    fn __repr__(self) -> None:
        """
        Print vector values
        """
        print(
            "Float64 [0]:",
            self.data[0],
            "Float64 [1]",
            self.data[1],
            "Float64 [2]",
            self.data[2],
        )

    @always_inline
    fn dot(self, other: Vec3) -> Float64:
        """
        Compute the dot product between a self and other.
        """
        return (self.data * other.data).reduce_add()

    fn cross(self, other: Vec3) -> Vec3:
        """
        Compute the cross product between self and other.
        """
        return Vec3(
            (self.data.shuffle[1, 2, 0, 3]() * other.data.shuffle[2, 0, 1, 3]())
            - (
                self.data.shuffle[2, 0, 1, 3]()
                * other.data.shuffle[1, 2, 0, 3]()
            )
        )

    fn unit_vector(self) -> Vec3:
        """
        Return the unit vector of self.
        """
        return self.data / self.length()

    fn __getitem__(self, index: Int) -> Float64:
        """
        Get item at a specific index.
        """
        return self.data[index]
