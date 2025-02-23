package main

vec2 :: [2]f32
vec3 :: [3]f32
vec4 :: [4]f32

Vertex_Attributes :: struct {
	pos:   vec3,
	color: vec3,
	uv:    vec2,
	scale: f32,
}
