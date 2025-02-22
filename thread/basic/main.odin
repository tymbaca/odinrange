package main

import "core:fmt"
import "core:math"
import "core:sync"
import "core:thread"
import "core:time"

WORKERS :: 10_000
WORKER_ITER :: 1_000_000

main :: proc() {
	data: f64 = 100
	mu := sync.Mutex{}
	wg := sync.Wait_Group{}

	threads: [WORKERS]^thread.Thread

	start := time.now()
	for i in 0 ..< WORKERS {
		if t := thread.create(worker); t != nil {
			sync.wait_group_add(&wg, 1)
			t.user_args[0] = &data
			t.user_args[1] = &mu
			t.user_args[2] = &wg

			threads[i] = t
			fmt.println(i)
		}
	}
	fmt.println("threads created:", time.since(start))

	start = time.now()
	for t in threads {
		thread.start(t)
	}
	fmt.println("threads started:", time.since(start))

	sync.wait(&wg)
	fmt.println("threads finished:", time.since(start))

	fmt.println(data)
}

h :: proc(v: $T) -> ^T {
	vp := new(type_of(v))
	vp^ = v

	return vp
}

worker :: proc(t: ^thread.Thread) {
	i := (^f64)(t.user_args[0])
	mu := (^sync.Mutex)(t.user_args[1])
	wg := (^sync.Wait_Group)(t.user_args[2])
	defer sync.wait_group_done(wg)

	//sync.mutex_lock(mu)

	for _ in 0 ..< WORKER_ITER {
		val := i^
		lg := math.log(val, 2)
		i^ += lg
	}

	//sync.mutex_unlock(mu)
}
