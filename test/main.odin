package main

import "core:fmt"
import "core:math/linalg"
import "core:reflect"
import "core:relative"

Zing :: struct {
	a: int,
}
Zong :: struct {
    a: int `json:"hello" bin:"test"`,
	b: int `json:"hello"`,
}

Thing :: union {
	^Zing,
	^Zong,
}

main :: proc() {
	for field in reflect.struct_fields_zipped(Zong) {
		fmt.println(field.offset, field.name, field.type, field.tag)
        fmt.println(reflect.struct_tag_lookup(field.tag, "bin"))
	}
}
