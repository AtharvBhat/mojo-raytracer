from vec3 import Vec3, Point3
from sphere import Sphere
from camera import Camera


fn main() raises -> None:
    var cam: Camera = Camera()
    # world
    var world = List[UnsafePointer[Sphere]]()
    world.append(Reference(Sphere(Point3(0, -100.5, -1), 100)))
    world.append(Reference(Sphere(Point3(0, 0, -1), 0.5)))

    # Render
    cam.render(world)
