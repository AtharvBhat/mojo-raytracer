import math
from math.limit import inf as math_inf
import vec3
from vec3 import Vec3, Point3
from color import Color3, get_color_data
from ray import Ray
from hittable import Hittable, HitRecord, HittableList
from sphere import Sphere

alias inf = math_inf[DType.float64]()


fn get_color(ray: Ray, world: HittableList) -> Color3:
    """
    Get the color of a ray in the scene.
    """
    var hit_record: HitRecord = HitRecord(
        Vec3(0, 0, 0), Vec3(0, 0, 0), 0, False
    )
    if world.hit(ray, 0, inf, hit_record):
        return (Color3(1, 1, 1) + hit_record.normal) / 2

    var unit_vector: Vec3 = ray.direction.unit_vector()
    # rescale "a" from -1,1 to 0,1
    var a: Float64 = (unit_vector.y() + 1) / 2
    return Color3(1.0, 1.0, 1.0) * (1.0 - a) + Color3(0.5, 0.7, 1.0) * a


fn main() raises -> None:
    var aspect_ratio: Float64 = 2.0 / 1.0

    # Image dimensions
    var img_width: Int = 2000
    var img_height: Int = math.max(
        int(img_width / aspect_ratio), 1
    )  # needs to be atleast 1

    # Camera
    var focal_length: Float64 = 1.0
    var viewport_height: Float64 = 2.0
    var viewport_width: Float64 = viewport_height * (
        img_width / img_height
    )  # use calculated aspect ratio instead of defined aspect ratio since it might be different
    var camera_center: Point3 = Point3(0, 0, 0)

    # vectors horizontally across and vertically downwards the viewport edges
    var viewport_u: Vec3 = Vec3(viewport_width, 0, 0)
    var viewport_v: Vec3 = Vec3(0, -viewport_height, 0)

    # calculate pixel delta vectors
    var pixel_delta_u: Vec3 = viewport_u / img_width
    var pixel_delta_v: Vec3 = viewport_v / img_height

    # calculate location of upper left pixel i.e. [0,0]
    var viewport_upper_left: Vec3 = camera_center - Vec3(
        0, 0, focal_length
    ) - viewport_u / 2 - viewport_v / 2
    var pixel_00_loc: Vec3 = viewport_upper_left - (
        pixel_delta_u + pixel_delta_v
    ) / 2

    # world
    var world = List[UnsafePointer[Sphere]]()
    world.append(Reference(Sphere(Point3(0, -100.5, -1), 100)))
    world.append(Reference(Sphere(Point3(0, 0, -1), 0.5)))

    # Render
    with open("image.ppm", "w") as image_file:
        # File Header
        var file_header: String = "P3\n"
        file_header += String(img_width) + " " + String(img_height)
        file_header += "\n255\n"
        image_file.write(file_header)

        # File Data
        for j in range(img_height):
            var file_data: String = ""
            print("Progress :", int(j * 100 / img_height), "%", end="\r")
            for i in range(img_width):
                # Find the center pixel and its direction
                var pixel_center: Vec3 = pixel_00_loc + (pixel_delta_u * i) + (
                    pixel_delta_v * j
                )
                var ray_direction: Vec3 = pixel_center - camera_center

                # shoot a ray from camera center into the direction of the pixel and get its color
                var ray = Ray(camera_center, ray_direction)
                var color = get_color(ray, world)
                file_data += get_color_data(color)

            image_file.write(file_data)
    print("\nDone!")
