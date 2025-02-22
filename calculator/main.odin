package main

import "core:fmt"
import "core:os"
import "core:strconv"

main :: proc() {
	args := os.args

	if len(args) != 4 {
		panic("ты долбоеб, напиши 3 аргрумента")
	}

	a := strconv.atoi(args[1])
	b := strconv.atoi(args[3])

	if a == 9 || b == 9 {
		panic("только долбоебы используют цифру 9")
	}

	switch args[2] {
	case "+":
		fmt.println(a + b)
	case "-":
		fmt.println(a - b)
	case "*":
		fmt.println(a * b)
	case "/":
		fmt.println(a / b)
	}
}
