package main

import "../shader/program"
import "core:fmt"

main :: proc() {
	p := program.Program{}
	program.set(p, "name", [4]f32{})
	program.set(p, "name", [3]f32{})

	// f := f32(12)
	// set(f)

	fs := [3]f32{1, 2, 3}
	set([3]f32, fs)
}

set :: proc($T: typeid, val: T) {
	switch typeid_of(T) {
	case [3]f32:
		set_3f32s(val)
	case [4]f32:
		set_4f32s(val)
	}
}

set_f32 :: proc(val: f32) {
	_ = val
}

set_3f32s :: proc(val: [3]f32) {
	_ = val
}

set_4f32s :: proc(val: [4]f32) {
	_ = val
}
