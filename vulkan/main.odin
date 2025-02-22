package main

import "vendor:glfw"
import vk "vendor:vulkan"

window: glfw.WindowHandle


init_window :: proc() {
	glfw.Init()
	glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	window = glfw.CreateWindow(800, 600, "test", nil, nil)
}

init_vulkan_instance :: #force_inline proc() -> vk.Instance {
    vk.load_proc_addresses(rawptr(glfw.GetInstanceProcAddress))
	instance: vk.Instance

	app_info := vk.ApplicationInfo {
		sType            = .APPLICATION_INFO,
		pApplicationName = "hello vulkan",
		apiVersion       = vk.API_VERSION_1_0,
	}

	create_info := vk.InstanceCreateInfo {
		sType            = .INSTANCE_CREATE_INFO,
		pApplicationInfo = &app_info,
	}

    if result := vk.CreateInstance(&create_info, nil, &instance); result != .SUCCESS {
        panic("error while init vulkan")
    }

    return instance
}

main_loop :: proc() {
    for !glfw.WindowShouldClose(window) {
        glfw.PollEvents()
    }
}

main :: proc() {
    init_window()
    init_vulkan_instance()
    main_loop()
}
