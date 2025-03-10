package main

import "../shader/program"
import "core:fmt"
import "core:image"
import "core:image/png"
import "core:bytes"
import "core:testing"
import rl "vendor:raylib"

main :: proc() {
    log(len("hello") == 5)
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
