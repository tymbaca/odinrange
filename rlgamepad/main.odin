package main

import "core:fmt"
import rl "vendor:raylib"

ball := struct {
	pos: [2]f32,
}{}

main :: proc() {
	rl.InitWindow(600, 400, "test")
    fmt.println(rl.IsGamepadAvailable(0))

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.GRAY)
        
        delta := rl.GetMouseDelta()
		// fmt.println(delta, rl.GetMouseX(), rl.GetMouseY())

        ball.pos += delta

        rl.DrawCircleV(ball.pos, 15, rl.RED)

		rl.EndDrawing()
	}
}
