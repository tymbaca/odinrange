package main

import "core:fmt"
import "core:math"
import "core:sync"
import "core:thread"
import "core:time"

WORKERS :: 10
WORKER_ITER :: 100
TASK_COUNT :: 10

main :: proc() {
	task_data := Task_Data {
		i   = 100,
		mu  = sync.Mutex{},
		job = real_job,
		wg  = sync.Wait_Group{},
	}

	pool: thread.Pool
	thread.pool_init(&pool, context.allocator, WORKERS)
	defer thread.pool_destroy(&pool)

	thread.pool_start(&pool)

	for _ in 0 ..< 200 {
		start := time.now()

		sync.wait_group_add(&task_data.wg, TASK_COUNT)

		for i in 0 ..< TASK_COUNT {
			thread.pool_add_task(&pool, context.allocator, worker, &task_data, user_index = i)
		}

		fmt.println("tasks added ----------------------")

		/*
		for task in thread.pool_pop_waiting(&pool) {
			thread.pool_do_work(&pool, task)
		}
		thread.pool_finish(&pool)
        */
		sync.wait(&task_data.wg)
		clear(&pool.tasks_done)

		fmt.println("| chunk tasks finished:", time.since(start))
		fmt.println(len(pool.tasks_done))
	}


	fmt.println(task_data.i)
}

Task_Data :: struct {
	i:   f64,
	mu:  sync.Mutex,
	job: proc(val: f64) -> f64,
	wg:  sync.Wait_Group,
}

worker :: proc(t: thread.Task) {
	td := (^Task_Data)(t.data)
	defer sync.wait_group_done(&td.wg)

	//sync.mutex_lock(&td.mu)

	fmt.print("X ")
	td.i = td.job(td.i)

	//sync.mutex_unlock(&td.mu)
}

real_job :: proc(val: f64) -> f64 {
	time.sleep(100 * time.Millisecond)

	return val + 1
}
