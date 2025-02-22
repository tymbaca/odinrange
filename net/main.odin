package main

import "core:fmt"
import "core:io"
import "core:net"
import "core:reflect"
import "core:relative"
import "core:strconv"

main :: proc() {
	r := Reader {
		self = &sock,
		read = read_tcp,
	}

	buf := make([]byte, 1024)
	for {
		n, err := r->read(buf)
		fmt.println(buf[:n], n, err)

		if err != nil {
			fmt.println("exiting")
			return
		}
	}
}

Reader :: struct {
	self: rawptr,
	read: proc(self: rawptr, buf: []byte) -> (n: int, err: Error),
}

Error :: union #shared_nil {
	io.Error,
	net.Network_Error,
}

new_tcp_reader :: proc(sock: net.TCP_Socket)

read_tcp :: proc(self: rawptr, buf: []byte) -> (n: int, err: Error) {
	sock := cast(^net.TCP_Socket)self
	n, err = net.recv_tcp(sock^, buf)
	return n, err
}
