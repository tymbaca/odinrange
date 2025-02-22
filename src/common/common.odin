package common

add :: proc(a, b: $T) -> T {
	return auto_cast (a + b)
}
