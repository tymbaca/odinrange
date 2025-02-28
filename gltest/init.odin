package main

import "base:runtime"
import "core:c"
import "core:fmt"
import "core:image"
import "core:image/png"
import "core:math"
import "core:time"
import "shader/program"
import gl "vendor:OpenGL"
import "vendor:glfw"
import rl "vendor:raylib"

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
	vs := []Vertex_Attributes {
        {pos = {-0.5, -0.5, 0}, color = {0.7, 0.0, 0.0}, uv = {0, 0}, scale = 0.5}, // 0 left down
	    {pos = {-0.5, 0.5, 0},  color = {0.0, 0.7, 0.0}, uv = {0, 1}, scale = 0.5}, // 1 left up
	    {pos = {0.5, 0.5, 0},   color = {0.0, 0.0, 0.7}, uv = {1, 1}, scale = 0.5}, // 2 right up
	    {pos = {0.5, -0.5, 0},  color = {0.0, 0.0, 0.0}, uv = {1, 0}, scale = 0.5}, // 3 right down
	    {pos = {0.6, 0, 0},     color = {0.7, 0.0, 0.0}, uv = {0, 0}, scale = 0.5}, // 4
	    {pos = {0.6, 0.4, 0},   color = {0.0, 0.7, 0.0}, uv = {0, 0}, scale = 0.5}, // 5
	    {pos = {0.9, 0, 0},     color = {0.0, 0.0, 0.7}, uv = {0, 0}, scale = 0.5}, // 6
	    {pos = {0, 0.5, 0},     color = {0.5, 0.5, 0.5}, uv = {0, 0}, scale = 0.5}, // 7 up
	}
	stride :: size_of(Vertex_Attributes)
    fmt.println("attr size ", size_of(Vertex_Attributes))

	indices := []u32 {
		0, 1, 2,
		0, 2, 3,
		// 4, 5, 6,
		// 0, 7, 3,
	}

	gl.GenVertexArrays(1, &VAO)
	gl.BindVertexArray(VAO)

	gl.GenBuffers(1, &VBO)
	gl.GenBuffers(1, &EBO)

	fmt.println(size_of(f32) * len(vs))
	gl.BindBuffer(gl.ARRAY_BUFFER, VBO)
	gl.BufferData(gl.ARRAY_BUFFER, size_of(Vertex_Attributes) * len(vs), raw_data(vs), gl.STATIC_DRAW)

	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, EBO)
	gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(u32) * len(indices), raw_data(indices), gl.STATIC_DRAW)

	posLoc :: 0
	gl.VertexAttribPointer(posLoc, 3, gl.FLOAT, false, stride, 0)
	gl.EnableVertexAttribArray(posLoc)

	colLoc :: 1
	gl.VertexAttribPointer(colLoc, 3, gl.FLOAT, false, stride, 3 * size_of(f32))
	gl.EnableVertexAttribArray(colLoc)

	uvLoc :: 2
	gl.VertexAttribPointer(uvLoc, 2, gl.FLOAT, false, stride, 6 * size_of(f32))
	gl.EnableVertexAttribArray(uvLoc)

	scaleLoc :: 3
	gl.VertexAttribPointer(scaleLoc, 1, gl.FLOAT, false, stride, 8 * size_of(f32))
	gl.EnableVertexAttribArray(scaleLoc)

	// gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	// gl.BindVertexArray(0)

	// gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)

	return true
}
