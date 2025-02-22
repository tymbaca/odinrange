package main

import imgui "../lib/imgui"
import imgui_rl "../lib/imgui/imgui_impl_raylib"
import rl "vendor:raylib"

main :: proc() {
	rl.SetConfigFlags({rl.ConfigFlag.WINDOW_RESIZABLE})
	rl.InitWindow(800, 600, "raylib basic window")
	defer rl.CloseWindow()

	imgui.CreateContext(nil)
	defer imgui.DestroyContext(nil)

	imgui_rl.init()
	defer imgui_rl.shutdown()

	imgui_rl.build_font_atlas()

	for !rl.WindowShouldClose() {
		imgui_rl.process_events()
		imgui_rl.new_frame()
		imgui.NewFrame()

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		imgui.ShowDemoWindow(nil)

		imgui.Render()
		imgui_rl.render_draw_data(imgui.GetDrawData())

		rl.EndDrawing()
	}

}
