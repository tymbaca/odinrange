package rl

import ".."
import rl "vendor:raylib"
import "vendor:raylib/rlgl"

drawer :: proc() -> draw.Drawer {
    return {
        rect = rect
    }
}

rect :: proc(pos, size: [2]i32, color: [4]u8, roundness: i32 = 0, segments: i32 = 0) {
    if roundness == 0 {
        rl.DrawRectangle(pos.x, pos.y, size.x, size.y, auto_cast color)
        return
    }

	rl.DrawRectangleRounded(
		rl.Rectangle{x = f32(pos.x), y = f32(pos.y), width = f32(size.x), height = f32(size.y)},
		f32(roundness),
		segments,
		auto_cast color,
	)
}
