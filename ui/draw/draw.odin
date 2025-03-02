package draw

Drawer :: struct {
    rect: proc(pos, size: [2]i32, color: [4]u8, roundness: i32 = 0, segments: i32 = 0),
}
