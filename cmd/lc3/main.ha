use fmt;
use io;
use fs;
use os;
use unix::tty;

use vm;
use vm::{PC_START};
use vm::utils::{cf};
use vm::registers;
use vm::registers::{reg, registers};
use vm::memory;
use vm::memory::{memory};

use fmt;
use io;


export fn main() void = {
	if (len(os::args) != 2) {
		fmt::fatalf("Usage: {} <image>", os::args[0]);
	};

	// We need to setup the TTY to make the keyboard act nicely.
	// Unrelated to VM work.
	let tio = tty::termios_query(os::stdin: io::file)!;
	tty::noecho(&tio)!;
	tty::noncanonical(&tio)!;
	defer tty::termios_restore(&tio);


	const path = os::args[1];

	let memory = memory::new();
	match (vm::read_image(path, &memory)) {
	case void =>
		fmt::println("Loaded image")!;
	case let err: fs::error =>
		fmt::fatalf("Failed to load VM image: {}",
			fs::strerror(err));
	};

	let regs   = registers::new();
	// Initialize registers.
	// Since there should always be a condition set, we start with the Z flag.
	regs[reg::COND] = cf::ZERO: u16;
	regs[reg::PC]   = vm::PC_START;

	let running = true;
	for (running) {
		let instr = next_instruction(&memory, &regs);
		if (vm::handle_instruction(instr, &memory, &regs)) break;
	};
};

fn next_instruction(memory: *memory, regs: *registers) u16 = {
	let pc = regs[reg::PC];	
	regs[reg::PC] += 1;
	return memory::read(memory, pc);
};
