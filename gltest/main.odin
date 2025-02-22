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
// import "vendor:OpenGL"

PROGRAMNAME :: "Program"
WIDTH :: 512
HEIGHT :: 512

GL_MAJOR_VERSION: c.int : 4
GL_MINOR_VERSION :: 1

VERTEX_SHADER :: "shader/vertex.glsl"
FRAGMENT_SHADER :: "shader/fragment.glsl"
PROGRAM: program.Program

_running: b32 = true
VAO: u32
VBO: u32
EBO: u32

START := time.now()

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

    PROGRAM = program.new(VERTEX_SHADER, FRAGMENT_SHADER) or_return

	// Own drawing code here
    vs := []f32{
      // position      color
        -0.5,-0.5, 0,  0.7, 0.0, 0.0, // 0 left down
        -0.5, 0.5, 0,  0.0, 0.7, 0.0, // 1 left up
         0.5, 0.5, 0,  0.0, 0.0, 0.7, // 2 right up
         0.5,-0.5, 0,  0.0, 0.0, 0.0, // 3 right down

         0.6,   0, 0,  0.7, 0.0, 0.0,
         0.6, 0.4, 0,  0.0, 0.7, 0.0,
         0.9,   0, 0,  0.0, 0.0, 0.7,
    }
    stride :: 6*size_of(f32)

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

    // gl.BindBuffer(gl.ARRAY_BUFFER, 0)
    // gl.BindVertexArray(0)

    // gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)

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


    program.use(PROGRAM)

    color: [4]f32
    color.r = auto_cast (math.sin(time.duration_seconds(time.since(START))) + 1) * 0.5
    program.set(PROGRAM, "color", color)

    gl.BindVertexArray(VAO)
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, EBO)
    gl.DrawElements(gl.TRIANGLES, 9, gl.UNSIGNED_INT, nil)
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
