from vec3 import Vec3

alias Color3 = Vec3


# TODO: Modify get color data and write color data once you implement an image class to decouple rendering and file saving
fn get_color_data(color: Color3) -> String:
    """
    Return the color data as a string.
    """
    var color_clamped = color.clamp(0, 1)
    var r = int(color_clamped[0] * 255)
    var g = int(color_clamped[1] * 255)
    var b = int(color_clamped[2] * 255)
    return String(r) + " " + String(g) + " " + String(b) + "\n"


fn write_color(color: Color3) -> None:
    """
    Return the color data as a string.
    """
    var r = int(color[0] * 255)
    var g = int(color[1] * 255)
    var b = int(color[2] * 255)
    print(String(r), String(g), String(b))
