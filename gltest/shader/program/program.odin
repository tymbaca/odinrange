package program

import "core:fmt"
import "core:os"
import "core:strings"
import "core:testing"
import gl "vendor:OpenGL"

Program :: struct {
	id: u32,
}

new :: proc(vertex_path, frag_path: string) -> (program: Program, ok: bool) {
	context.allocator = context.temp_allocator
	defer free_all(context.allocator)

	vertex := shader_from_filename(vertex_path, .VERTEX_SHADER) or_return
	defer gl.DeleteShader(vertex)
	fragment := shader_from_filename(frag_path, .FRAGMENT_SHADER) or_return
	defer gl.DeleteShader(fragment)

	program_id := gl.create_and_link_program({vertex, fragment}) or_return

	return Program{id = program_id}, true
}

use :: proc(p: Program) {
	gl.UseProgram(p.id)
}

set :: proc{ set_float, set_vec2f, set_vec3f, set_vec4f,  }

set_float :: proc(p: Program, name: string, val: f32) {
	loc := gl.GetUniformLocation(p.id, strings.clone_to_cstring(name, context.temp_allocator))
	defer free_all(context.temp_allocator)
    gl.Uniform1f(loc, val)
}

set_vec2f :: proc(p: Program, name: string, val: [2]f32) {
	loc := gl.GetUniformLocation(p.id, strings.clone_to_cstring(name, context.temp_allocator))
	defer free_all(context.temp_allocator)
    gl.Uniform2f(loc, val.x, val.y)
}

set_vec3f :: proc(p: Program, name: string, val: [3]f32) {
	loc := gl.GetUniformLocation(p.id, strings.clone_to_cstring(name, context.temp_allocator))
	defer free_all(context.temp_allocator)
    gl.Uniform3f(loc, val.x, val.y, val.z)
}

set_vec4f :: proc(p: Program, name: string, val: [4]f32) {
	loc := gl.GetUniformLocation(p.id, strings.clone_to_cstring(name, context.temp_allocator))
	defer free_all(context.temp_allocator)
    gl.Uniform4f(loc, val.x, val.y, val.z, val.w)
}

shader_from_filename :: proc(
	path: string,
	shader_type: gl.Shader_Type,
) -> (
	shader: u32,
	ok: bool,
) {
	bytes := os.read_entire_file(path) or_return
	str := string(bytes)
	return gl.compile_shader_from_source(str, shader_type)
}
