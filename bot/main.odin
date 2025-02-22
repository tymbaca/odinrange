package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:time"

main :: proc() {
	args := os.args

	chinazes_count := strconv.atoi(args[1])

	for i in 0 ..< chinazes_count {
		fmt.print("наконец-то тархун ")
		if i == 100_000 {
			time.sleep(1 * time.Second)
		}
	}
	fmt.print("\n")
}
