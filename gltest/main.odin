package main

import "core:fmt"
import "core:c"
import gl "vendor:OpenGL"
import "vendor:glfw"
import "base:runtime"
import rl "vendor:raylib"
// import "vendor:OpenGL"

PROGRAMNAME :: "Program"
WIDTH :: 512
HEIGHT :: 512

GL_MAJOR_VERSION: c.int : 4
GL_MINOR_VERSION :: 1

VERTEX_SHADER :: string(#load("shader/vertex.glsl"))
FRAGMENT_SHADER :: string(#load("shader/fragment.glsl"))

_running: b32 = true
SHADER_PROGRAM: u32
VAO: u32
VBO: u32
EBO: u32

main :: proc() {
	if !glfw.Init() {
		fmt.println("Failed to initialize GLFW")
		return
	}
	defer glfw.Terminate()

    glfw.WindowHint(glfw.RESIZABLE, true)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, true)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)

	window := glfw.CreateWindow(WIDTH, HEIGHT, PROGRAMNAME, nil, nil)
	defer glfw.DestroyWindow(window)

	if window == nil {
		fmt.println("Unable to create window")
		return
	}

	glfw.MakeContextCurrent(window)

	glfw.SwapInterval(1)

	glfw.SetKeyCallback(window, key_callback)

	glfw.SetFramebufferSizeCallback(window, size_callback)

	gl.load_up_to(int(GL_MAJOR_VERSION), GL_MINOR_VERSION, glfw.gl_set_proc_address)

	if ok := init(); !ok {
        fmt.println("can't init")
        return
    }

	for (!glfw.WindowShouldClose(window) && _running) {
		glfw.PollEvents()

		update()
		draw()

		glfw.SwapBuffers((window))
	}

	exit()

}


init :: proc() -> (ok: bool) {
    fmt.println("OpenGL Version: ", gl.GetString(gl.VERSION))
    fmt.println("GLSL Version: ", gl.GetString(gl.SHADING_LANGUAGE_VERSION))

	// Own initialization code there
    vertex_shader := gl.compile_shader_from_source(VERTEX_SHADER, .VERTEX_SHADER) or_return
    defer gl.DeleteShader(vertex_shader)

    fragment_shader := gl.compile_shader_from_source(FRAGMENT_SHADER, .FRAGMENT_SHADER) or_return
    defer gl.DeleteShader(fragment_shader)

    SHADER_PROGRAM = gl.create_and_link_program({vertex_shader, fragment_shader}) or_return

	// Own drawing code here
    vs := []f32{
        -0.5,-0.5, 0, // 0 left down
        -0.5, 0.5, 0, // 1 left up
         0.5, 0.5, 0, // 2 right up
         0.5,-0.5, 0, // 3 right down
    }

    indices := []u32{
        0, 1, 2,
        0, 2, 3,
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

    gl.VertexAttribPointer(0, 3, gl.FLOAT, false, 3*size_of(f32), 0)
    gl.EnableVertexAttribArray(0)

    // gl.BindBuffer(gl.ARRAY_BUFFER, 0)
    // gl.BindVertexArray(0)

    return true
}

update :: proc() {
	// Own update code here
}

draw :: proc() {
	// Set the opengl clear color
	// 0-1 rgba values
	gl.ClearColor(0.2, 0.3, 0.3, 1.0)
	// Clear the screen with the set clearcolor
	gl.Clear(gl.COLOR_BUFFER_BIT)


    gl.UseProgram(SHADER_PROGRAM)
    gl.BindVertexArray(VAO)
    // gl.DrawArrays(gl.TRIANGLES, 0, 3)
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, EBO)
    gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, auto_cast uintptr(0))
}

exit :: proc() {
	// Own termination code here
}

// Called when glfw keystate changes
key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	// Exit program on escape pressed
	if key == glfw.KEY_ESCAPE {
		_running = false
	}
}

// Called when glfw window changes size
size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	// Set the OpenGL viewport size
	gl.Viewport(0, 0, width, height)
}
