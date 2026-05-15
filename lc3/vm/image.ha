use os;
use fs;
use io;
use fmt;
use endian;

use lc3::vm::memory;
use lc3::vm::memory::{memory};

// Where in virtual memory our program lives. For our architecture, we it will
// live at address 0x3000 and onwards.
export def PC_START: u16 = 0x3000;

// Reads the program image into memory.
export fn read_image(file_name: str, mem: *memory) (void | io::EOF | fs::error) = {
	const file = os::open(file_name)?;
	defer io::close(file)!;

	// An actual thing to know is that when we are reading u8s, the actual
	// values stored here are in big-endian, so we have to account for this
	// when reading/converting words into memory.
	let image_bytes = io::drain(file)?;
	defer free(image_bytes);

	// First read the origin of the program.
	let origin = endian::begetu16([image_bytes[0], image_bytes[1]]);

	// The base pointer from where we should write the image into.
	// We start at offset `origin`, and write all the program bytes into memory
	let addr   = origin: size;
	// skip first two bytes since it contains the origin.
	// and jump by two since we are reading u16s
	for (let i = 2z; i + 1 < len(image_bytes); i += 2) {
		let w = endian::begetu16([image_bytes[i], image_bytes[i+1]]);
		memory::write(mem, addr, w);
		addr += 1;
	};
};
