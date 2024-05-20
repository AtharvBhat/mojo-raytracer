from vec3 import Vec3, Point3


struct Ray:
    var origin: Point3
    var direction: Vec3

    @always_inline
    fn __init__(inout self, origin: Point3, direction: Vec3) -> None:
        """
        Init Ray from origin, pointing to direction.
        """
        self.origin = origin
        self.direction = direction

    @always_inline
    fn at(self, t: Float64) -> Point3:
        """
        Moves point from origin to the direction it points in by "t".

        Args:
            t: Magnitude by which to move Ray in a direction.

        Returns:
            Position in the direction a ray points in.
        """
        return self.origin + self.direction * t
