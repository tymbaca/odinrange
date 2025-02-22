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

draw :: proc() {
	// Set the opengl clear color
	// 0-1 rgba values
	gl.ClearColor(0.2, 0.3, 0.3, 1.0)
	// Clear the screen with the set clearcolor
	gl.Clear(gl.COLOR_BUFFER_BIT)


    program.use(PROGRAM)

    color: [4]f32
    color.r = auto_cast (math.sin(time.duration_seconds(time.since(START))) + 1) * 0.5
    program.set(PROGRAM, "color", color)

    gl.BindVertexArray(VAO)
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, EBO)
    gl.DrawElements(gl.TRIANGLES, 9, gl.UNSIGNED_INT, nil)
}
