package main

import "../shader/program"
import "core:fmt"
import "core:image"
import "core:image/png"
import "core:bytes"

main :: proc() {
    img, ierr := image.load_from_file("resources/wall.png", {.alpha_add_if_missing})
    if ierr != nil {
        fmt.println(ierr)
        return
    }

    b: [12]byte
    n, rerr := bytes.buffer_read(&img.pixels, b[:])
    if rerr != nil {
        fmt.println(rerr)
        return 
    }
    
    fmt.println(b)
}
