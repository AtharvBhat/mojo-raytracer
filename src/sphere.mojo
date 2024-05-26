from hittable import Hittable, HitRecord
from vec3 import Vec3, Point3
from ray import Ray
import vec3
import math


struct Sphere(Hittable):
    var center: Point3
    var radius: Float64

    fn __init__(inout self, center: Point3, radius: Float64) -> None:
        self.center = center
        self.radius = math.max(0.0, radius)

    fn hit(
        self,
        ray: Ray,
        ray_tmin: Float64,
        ray_tmax: Float64,
        inout hit_record: HitRecord,
    ) -> Bool:
        """
        Test if a ray hits the sphere.
        If yes, update hit_record with the t.
        """
        var oc: Vec3 = self.center - ray.origin
        var a: Float64 = ray.direction.length_squared()
        var h: Float64 = vec3.dot(ray.direction, oc)
        var c: Float64 = oc.length_squared() - self.radius**2

        var discriminant: Float64 = h**2 - a * c
        if discriminant < 0.0:
            return False

        var sqrtd = math.sqrt(discriminant)

        # find closest root
        var root: Float64 = (h - sqrtd) / a
        if root <= ray_tmin or ray_tmax <= root:
            root = (h + sqrtd) / a
            if root <= ray_tmin or ray_tmax <= ray_tmax:
                return False

        hit_record.t = root
        hit_record.p = ray.at(root)
        var normal: Vec3 = (hit_record.p - self.center) / self.radius
        hit_record.set_face_normal(ray, normal)

        return True
