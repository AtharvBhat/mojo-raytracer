import math
from vec3 import Vec3
from color import Color3, get_color


fn main() raises -> None:
    # Image dimensions
    alias img_height: Int = 1080
    alias img_width: Int = 1080

    # Render
    with open("image.ppm", "w") as image_file:
        # Header
        var file_header: String = "P3\n"
        file_header += String(img_width) + " " + String(img_height)
        file_header += "\n255\n"
        image_file.write(file_header)

        # Data
        for j in range(img_height):
            var file_data: String = ""
            print("Progress :", int(j * 100 / img_height), "%", end="\r")
            for i in range(img_width):
                var color = Color3(
                    i / img_height,
                    j / img_width,
                    (img_width - i + img_height - j) / (img_height + img_width),
                )

                file_data += get_color(color)

            image_file.write(file_data)
    print("\nDone!")
