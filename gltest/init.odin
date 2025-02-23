package main

import "core:fmt"
import "core:c"
import gl "vendor:OpenGL"
import "vendor:glfw"
import "base:runtime"
import rl "vendor:raylib"
import "core:math"
import "core:time"
import "shader/program"
import "core:image"
import "core:image/png"

init :: proc() -> (ok: bool) {
    fmt.println("OpenGL Version: ", gl.GetString(gl.VERSION))
    fmt.println("GLSL Version: ", gl.GetString(gl.SHADING_LANGUAGE_VERSION))

    img, err := image.load_from_file("resources/wall.png")
    if err != nil {
        fmt.println(err)
        return false
    }
    defer image.destroy(img)

    wall_texture: u32
    gl.GenTextures(1, &wall_texture)
    gl.BindTexture(gl.TEXTURE_2D, wall_texture)

    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)

    gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, auto_cast img.width, auto_cast img.height, 0, gl.RGB, gl.UNSIGNED_BYTE, raw_data(img.pixels.buf))
    gl.GenerateMipmap(gl.TEXTURE_2D)

    PROGRAM = program.new(VERTEX_SHADER, FRAGMENT_SHADER) or_return

	// Own drawing code here
    vs := []f32{
      // position      color          scale
        -0.5,-0.5, 0,  0.7, 0.0, 0.0, 0, 0, 0.5, // 0 left down
        -0.5, 0.5, 0,  0.0, 0.7, 0.0, 0, 1, 0.5, // 1 left up
         0.5, 0.5, 0,  0.0, 0.0, 0.7, 1, 1, 0.5, // 2 right up
         0.5,-0.5, 0,  0.0, 0.0, 0.0, 1, 0, 0.5, // 3 right down

         0.6,   0, 0,  0.7, 0.0, 0.0, 0, 0, 0.5, // 4
         0.6, 0.4, 0,  0.0, 0.7, 0.0, 0, 0, 0.5, // 5
         0.9,   0, 0,  0.0, 0.0, 0.7, 0, 0, 0.5, // 6

         0,   0.5, 0,  0.5, 0.5, 0.5, 0, 0, 0.5, // 7 up
    }
    stride :: 9*size_of(f32)

    indices := []u32{
        0, 1, 2,
        0, 2, 3,
        // 4, 5, 6,
        // 0, 7, 3,
    }

    gl.GenVertexArrays(1, &VAO)
    gl.BindVertexArray(VAO)

    gl.GenBuffers(1, &VBO)
    gl.GenBuffers(1, &EBO)

    fmt.println(size_of(f32)*len(vs))
    gl.BindBuffer(gl.ARRAY_BUFFER, VBO)
    gl.BufferData(gl.ARRAY_BUFFER, size_of(f32)*len(vs), raw_data(vs), gl.STATIC_DRAW)

    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, EBO)
    gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(u32)*len(indices), raw_data(indices), gl.STATIC_DRAW)

    posLoc :: 0
    gl.VertexAttribPointer(posLoc, 3, gl.FLOAT, false, stride, 0)
    gl.EnableVertexAttribArray(posLoc)

    colLoc :: 1
    gl.VertexAttribPointer(colLoc, 3, gl.FLOAT, false, stride, 3*size_of(f32))
    gl.EnableVertexAttribArray(colLoc)

    uvLoc :: 2
    gl.VertexAttribPointer(uvLoc, 2, gl.FLOAT, false, stride, 6*size_of(f32))
    gl.EnableVertexAttribArray(uvLoc)

    scaleLoc :: 3
    gl.VertexAttribPointer(scaleLoc, 1, gl.FLOAT, false, stride, 8*size_of(f32))
    gl.EnableVertexAttribArray(scaleLoc)

    // gl.BindBuffer(gl.ARRAY_BUFFER, 0)
    // gl.BindVertexArray(0)

    // gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)

    return true
}
