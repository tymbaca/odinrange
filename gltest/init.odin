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

init :: proc() -> (ok: bool) {
    fmt.println("OpenGL Version: ", gl.GetString(gl.VERSION))
    fmt.println("GLSL Version: ", gl.GetString(gl.SHADING_LANGUAGE_VERSION))

    PROGRAM = program.new(VERTEX_SHADER, FRAGMENT_SHADER) or_return

	// Own drawing code here
    vs := []f32{
      // position      color          scale
        -0.5,-0.5, 0,  0.7, 0.0, 0.0, 0.5, // 0 left down
        -0.5, 0.5, 0,  0.0, 0.7, 0.0, 0.5, // 1 left up
         0.5, 0.5, 0,  0.0, 0.0, 0.7, 0.5, // 2 right up
         0.5,-0.5, 0,  0.0, 0.0, 0.0, 0.5, // 3 right down

         0.6,   0, 0,  0.7, 0.0, 0.0, 0.5,
         0.6, 0.4, 0,  0.0, 0.7, 0.0, 0.5,
         0.9,   0, 0,  0.0, 0.0, 0.7, 0.5,
    }
    stride :: 7*size_of(f32)

    indices := []u32{
        0, 1, 2,
        0, 2, 3,
        4, 5, 6,
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

    scaleLoc :: 2
    gl.VertexAttribPointer(scaleLoc, 1, gl.FLOAT, false, stride, 6*size_of(f32))
    gl.EnableVertexAttribArray(scaleLoc)

    // gl.BindBuffer(gl.ARRAY_BUFFER, 0)
    // gl.BindVertexArray(0)

    // gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)

    return true
}
