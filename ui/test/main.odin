package main

import "core:fmt"
import ".."
import "../draw"
import draw_gl "../draw/gl"
import draw_rl "../draw/rl"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(600, 400, "test")

    drawer := draw_rl.drawer()
    root := ui.Container{
        size = {width = 300, height = 200},
        color = auto_cast rl.WHITE,
        padding = {20, 20, 20, 20},
        gap = 20,
        roundness = 0,
        children = {
            {
                size = {50, 50},
                color = auto_cast rl.RED,
            },
            {
                size = {50, 50},
                color = auto_cast rl.GREEN,
            },
            {
                size = {50, 50},
                color = auto_cast rl.BLUE,
            },
        }
    }

    ctx := ui.create_context(root, drawer)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

        if rl.IsKeyReleased(.D) {
            ctx.root.gap += 1
        }
        if rl.IsKeyReleased(.A) {
            ctx.root.gap -= 1
        }
        if rl.IsKeyReleased(.H) {
            ctx.root.direction = .horisontal
        }
        if rl.IsKeyReleased(.V) {
            ctx.root.direction = .vertical
        }
        ui.render(ctx)
        fmt.println(root.gap)

		rl.EndDrawing()
	}
}
