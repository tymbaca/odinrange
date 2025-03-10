package main

import "../shader/program"
import "core:fmt"
import "core:image"
import "core:image/png"
import "core:bytes"
import "core:testing"
import rl "vendor:raylib"
import "core:math/linalg"
import "core:math"

vec2 :: [2]f32
vec3 :: [3]f32

dot :: linalg.dot
cross :: linalg.cross
cos :: linalg.cos
acos :: linalg.acos
DEG_PER_RAD :: linalg.DEG_PER_RAD
RAD_PER_DEG :: linalg.RAD_PER_DEG
normalize :: linalg.normalize

main :: proc() {
    {
        v1 := vec2{1, 0}
        v2 := vec2{0, 1}
        
        fmt.println(v1 * v2)
        fmt.println(dot(v1, v2))
        fmt.println(dot(normalize(v1), normalize(v2)))
        fmt.println(acos(dot(normalize(v2), normalize(v1))) * DEG_PER_RAD)
        fmt.println(acos(dot(v2, v1)) * DEG_PER_RAD)
    }
    // log(len("hello") == 5)
}

log :: proc(cond: bool, msg := #caller_expression(cond))  {
    fmt.println(msg)
}

@(test)
main_test :: proc(t: ^testing.T) {
    
    // {
    //     paths := make([]string, 3)
    //     paths = []string{"resources/wall.png", "resources/container.png", "resources/awesomeface.png"}
    //     for path, i in paths {
    //         fmt.println(path)
    //     }
    // }
    //
    // {
    //     wall := "resources/wall.png"
    //     container := "resources/container.png"
    //     awesomeface := "resources/awesomeface.png"
    //     paths := []string{wall, container, awesomeface}
    //     for path, i in paths {
    //         fmt.println(path)
    //     }
    // }

    // {
    //     for path, i in []string{"resources/wall.png", "resources/container.png", "resources/awesomeface.png"} {
    //         fmt.println(path)
    //     }
    // }
}
