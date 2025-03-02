package ui

import "core:os"
import "core:hash"
import "core:net"
import "core:log"
import "core:fmt"
import "core:mem"
import rl "vendor:raylib"
import "draw"
import draw_gl "draw/gl"
import draw_rl "draw/rl"

ivec2 :: [2]i32
Color :: [4]u8

Context :: struct {
    origin:       [2]i32,
	root:      Container,
	allocator: mem.Allocator,
	drawer:    draw.Drawer,
}

create_context :: proc(root: Container, drawer: draw.Drawer, allocator := context.allocator) -> Context {
    return {
        root = root,
        drawer = drawer,
        allocator = allocator,
    }
}

destroy_context :: proc(ctx: Context) {
    free_all(ctx.allocator)
}

render :: proc(ctx: Context) {
    draw_container(ctx, ctx.root)
}

draw_container :: proc(ctx: Context, container: Container) {
    ctx.drawer.rect(ctx.origin, {container.size.width, container.size.height}, container.color, container.roundness, 10)

    for child, i in container.children {
        child_ctx := ctx
        child_ctx.origin.x += 20 * auto_cast i
        draw_container(child_ctx, child)
    }
}

Container :: struct {
	size:     Size,
	color:    Color,
	roundness:  i32,
	padding:  [4]i32,
	gap:      i32,
	// parent:   ^Container,
	children: []Container,
    direction: Direction,
}

Direction :: enum {
    horisontal,
    vertical,
}

Size :: struct {
	width, height: Dimention,
}

Dimention :: i32
// Dimention :: union {
// 	i32,
// 	// Fit,
// 	// Hug,
// }

Fit :: struct {}
Hug :: struct {}

