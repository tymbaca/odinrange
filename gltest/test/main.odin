package main

import "../shader/program"

main :: proc() {
    p := program.Program{}
    program.set(p, "name", [4]f32{})
    program.set(p, "name", [3]f32{})
}

