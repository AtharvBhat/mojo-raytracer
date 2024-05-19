from vec3 import Vec3

alias Color3 = Vec3


fn get_color(color: Color3) -> String:
    """
    Return the color data as a string.
    """
    var r = int(color[0] * 255)
    var g = int(color[1] * 255)
    var b = int(color[2] * 255)
    return String(r) + " " + String(g) + " " + String(b) + "\n"


fn write_color(color: Color3) -> None:
    """
    Return the color data as a string.
    """
    var r = int(color[0] * 255)
    var g = int(color[1] * 255)
    var b = int(color[2] * 255)
    print(String(r), String(g), String(b))
