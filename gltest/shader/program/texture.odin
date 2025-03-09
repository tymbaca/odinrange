package program

import "core:image"
import "core:image/png"
import "core:log"
import gl "vendor:OpenGL"

Texture :: struct {
	id:     u32,
	width:  int,
	height: int,
}

load_texture :: proc(path: string, generate_mipmap := true) -> (texture: Texture, ok: bool) {
	img, err := image.load_from_file(path, {.alpha_add_if_missing})
	if err != nil {
        log.error(err)
		return {}, false
	}
	defer image.destroy(img)

	texture_id: u32
	gl.GenTextures(1, &texture_id)
	gl.BindTexture(gl.TEXTURE_2D, texture_id)

	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)

	gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, auto_cast img.width, auto_cast img.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, raw_data(img.pixels.buf))

    if generate_mipmap {
        gl.GenerateMipmap(gl.TEXTURE_2D)
    }

	return {
        id = texture_id,
        width = img.width,
        height = img.height,
    }, true
}
