from ray import Ray
from vec3 import Vec3, Point3
from collections import List
from interval import Interval
import interval
import math


@value
struct HitRecord:
    var p: Point3
    var normal: Vec3
    var t: Float64
    var front_face: Bool

    fn set_face_normal(inout self, ray: Ray, outward_normal: Vec3) -> None:
        """
        Calculate Outward facing normal.
        """
        self.front_face = vec3.dot(ray.direction, outward_normal) < 0.0
        self.normal = outward_normal if self.front_face else -outward_normal


trait Hittable:
    fn hit(
        self,
        ray: Ray,
        interval: Interval,
        inout hit_record: HitRecord,
    ) -> Bool:
        ...


struct HittableList[T: Hittable](Hittable):
    var hittable_list: List[UnsafePointer[T]]

    fn __init__(inout self) -> None:
        self.hittable_list = List[UnsafePointer[T]]()

    fn __init__(inout self, hittable_list: List[UnsafePointer[T]]) -> None:
        self.hittable_list = hittable_list

    fn add(inout self, hittable_ref: UnsafePointer[T]) -> None:
        self.hittable_list.append(hittable_ref)

    fn clear(owned self) -> None:
        self.hittable_list.clear()

    fn hit(
        self,
        ray: Ray,
        interval: Interval,
        inout hit_record: HitRecord,
    ) -> Bool:
        """
        For each object in the hittable list, check if a ray hits the object.
        If yes, update the t in hit_record.
        """
        var temp_hit_record: HitRecord = HitRecord(
            Point3(0, 0, 0), Vec3(0, 0, 0), 0.0, False
        )
        var hit_anything = False
        var closest = interval.max

        for i in range(len(self.hittable_list)):
            if self.hittable_list[i][].hit(
                ray, Interval(interval.min, closest), temp_hit_record
            ):
                hit_anything = True
                closest = temp_hit_record.t
                hit_record = temp_hit_record

        return hit_anything
