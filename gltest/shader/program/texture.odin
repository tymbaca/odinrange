package program

import "core:image"
import gl "vendor:OpenGL"

load_texture :: proc(path: string) -> (obj: u32, err: image.Error) {
	img := image.load_from_file("resources/wall.png") or_return
	defer image.destroy(img)

	texture: u32
	gl.GenTextures(1, &texture)

    return texture
}
