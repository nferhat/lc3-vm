use io;
use os;
use fs;
use fmt;
use unix::poll;

use lc3::{word, MEMORY_SIZE};

// The memory of the VM.
// With the word size being 2 bytes (u16s), this means there's ~131kB of addressable memory.
export type memory = [MEMORY_SIZE]word;

// Creates a new memory for a VM.
export fn new() memory = [0...];

// Reads a given address from memory, returning a WORD.
// Since we have only fucking ni
export fn read(mem: *memory, addr: size) word = {
	if (addr == memoryreg::KBSR) {
		if (check_key()!) {
			mem[memoryreg::KBSR] = (1 << 15);
			mem[memoryreg::KBDR] = getchar();
		} else {
			mem[memoryreg::KBSR] = 0;
		};
	};
	return mem[addr];
};

// Memory mapped register
type memoryreg = enum size { KBSR = 0xFE00, KBDR = 0xFE02 };

// Writes the given `word` inside the address `addr` in memory.
export fn write(mem: *memory, addr: size, word: word) void = {
	mem[addr] = word;
};

// Returns true if stdin has data available to read right now, else false.
fn check_key() (bool | poll::error) = {
	let fds = [poll::pollfd {
		fd = os::stdin: io::file,
		events = poll::event::POLLIN,
		revents = 0,
	}];

	// NONBLOCK = 0 duration => return immediately
	const nready = poll::poll(fds, poll::NONBLOCK)?;

	// If any fds are ready (nready > 0) and stdin has POLLIN set.
	return nready > 0 && (fds[0].revents & poll::event::POLLIN) != 0;
};

// `getchar()` implementation using hare's I/O primitives
fn getchar() word = {
	let char = 0u8;
	io::read(os::stdin, &char: *[1]u8)!;
	return char: word;
};
