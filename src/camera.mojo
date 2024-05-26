from hittable import HittableList, HitRecord
from interval import Interval, inf
from vec3 import Vec3, Point3
from ray import Ray
from color import Color3, get_color_data
import math


struct Camera:
    var aspect_ratio: Float64
    var image_width: Int
    var image_height: Int
    var center: Point3
    var pixel_00_loc: Point3
    var pixel_delta_u: Vec3
    var pixel_delta_v: Vec3

    fn __init__(inout self) -> None:
        self.image_width = 2000
        self.aspect_ratio = 2.0
        self.image_height = math.max(
            1, int(self.image_width / self.aspect_ratio)
        )

        self.center = Point3(0, 0, 0)
        var focal_length: Float64 = 1.0
        var viewport_height: Float64 = 2.0
        var viewport_width: Float64 = viewport_height * (
            self.image_width / self.image_height
        )

        var viewport_u: Vec3 = Vec3(viewport_width, 0, 0)
        var viewport_v: Vec3 = Vec3(0, -viewport_height, 0)

        self.pixel_delta_u = viewport_u / self.image_width
        self.pixel_delta_v = viewport_v / self.image_height

        var viewport_upper_left: Vec3 = self.center - Vec3(
            0, 0, focal_length
        ) - viewport_v / 2 - viewport_u / 2
        self.pixel_00_loc = (
            viewport_upper_left
            + self.pixel_delta_u / 2
            + self.pixel_delta_v / 2
        )

    fn ray_color(self, ray: Ray, world: HittableList) -> Color3:
        """
        Get the color of a ray in the scene.
        """
        var hit_record: HitRecord = HitRecord(
            Vec3(0, 0, 0), Vec3(0, 0, 0), 0, False
        )
        if world.hit(ray, Interval(0, inf), hit_record):
            return (Color3(1, 1, 1) + hit_record.normal) / 2

        var unit_vector: Vec3 = ray.direction.unit_vector()
        # rescale "a" from -1,1 to 0,1
        var a: Float64 = (unit_vector.y() + 1) / 2
        return Color3(1.0, 1.0, 1.0) * (1.0 - a) + Color3(0.5, 0.7, 1.0) * a

    fn render_pixel(
        self, pixel_x: Int, pixel_y: Int, world: HittableList
    ) -> Color3:
        var pixel_center: Point3 = self.pixel_00_loc + self.pixel_delta_u * pixel_x + self.pixel_delta_v * pixel_y
        var ray_direction: Vec3 = pixel_center - self.center
        var ray: Ray = Ray(self.center, ray_direction)
        return self.ray_color(ray, world)

    fn render(self, world: HittableList) raises -> None:
        with open("image.ppm", "w") as image_file:
            # File Header
            var file_header: String = "P3\n"
            file_header += (
                String(self.image_width) + " " + String(self.image_height)
            )
            file_header += "\n255\n"
            image_file.write(file_header)
            for j in range(self.image_height):
                var file_data: String = ""
                print(
                    "Progress :",
                    int(j * 100 / self.image_height),
                    "%",
                    end="\r",
                )
                for i in range(self.image_width):
                    var color: Color3 = self.render_pixel(i, j, world)
                    file_data += get_color_data(color)
                image_file.write(file_data)

        print("\nDone!")