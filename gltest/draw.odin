package main

import "core:fmt"
import "core:c"
import gl "vendor:OpenGL"
import "vendor:glfw"
import "base:runtime"
import rl "vendor:raylib"
import "core:math"
import "core:math/linalg"
import "core:time"
import "shader/program"

draw :: proc() {
	// Set the opengl clear color
	// 0-1 rgba values
	gl.ClearColor(0.2, 0.3, 0.3, 1.0)
	// Clear the screen with the set clearcolor
	gl.Clear(gl.COLOR_BUFFER_BIT)


    gl.ActiveTexture(gl.TEXTURE0)
    gl.BindTexture(gl.TEXTURE_2D, TEXTURES[.wall].id)
    gl.ActiveTexture(gl.TEXTURE1)
    gl.BindTexture(gl.TEXTURE_2D, TEXTURES[.awesomeface].id)

    program.use(PROGRAM)

    global_time := 30*f32(time.duration_seconds(time.since(START)))
    // factor := math.sin(time.duration_seconds(time.since(START)))
    factor := 1

    // color: [4]f32
    // color.r = auto_cast (factor + 1) * 0.5
    // program.set(PROGRAM, "color", color)
    program.set(PROGRAM, "globalScale", f32(factor))

    transform := linalg.identity_matrix(mat4)
    transform = linalg.matrix4_rotate_f32(global_time*RAD_PER_DEG, vec3{0,0,1}) * transform
    transform = linalg.matrix4_scale_f32(vec3{0.5,0.5,0.5}) * transform
    transform = linalg.matrix4_translate_f32(vec3{0,-0.2,0}) * transform
    program.set(PROGRAM, "transform", transform)

    gl.BindVertexArray(VAO)
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, EBO)
    gl.DrawElements(gl.TRIANGLES, 9, gl.UNSIGNED_INT, nil)
}
