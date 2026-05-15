use fmt;
use io;
use fs;
use os;
use getopt;
use unix::tty;

use lc3;
use lc3::{reg};
use lc3::vm;
use lc3::vm::memory;
use lc3::vm::registers;
use lc3::vm::{PC_START};


export fn main() void = {
	let dump_registers = false;

	const cmd = getopt::parse(os::args,
		"LC-3 Virtual Machine",
		('d', "dump register state at the end"),
		"<file>",
    );
	for (let opt .. cmd.opts) {
	    switch (opt.0) {
		case 'd' =>
		    dump_registers = true;
		case => abort();
		};
	};
    defer getopt::finish(&cmd);

    if (len(cmd.args) != 1) {
        getopt::printhelp(os::stdout, os::args[0],
            [('d', "dump register state at the end"),
    		"<file>"],
        )!;
        os::exit(os::status::FAILURE);
    };

	// We need to setup the TTY to make the keyboard act nicely.
	// Unrelated to VM work.
	let tio = tty::termios_query(os::stdin_file)!;
	tty::noecho(&tio)!;
	tty::noncanonical(&tio)!;
	defer tty::termios_restore(&tio);

	const path = cmd.args[0];

	let memory = memory::new();
	match (vm::read_image(path, &memory)) {
	case let err: fs::error =>
		fmt::fatalf("Failed to load VM image: {}",
			fs::strerror(err));
	case =>
	    yield;
	};

	let regs   = registers::new();
	// Initialize registers.
	// Since there should always be a condition set, we start with the Z flag.
	regs[reg::COND] = lc3::cf::ZERO: u16;
	regs[reg::PC]   = vm::PC_START;

	let running = true;
	for (running) {
		let instr = next_instruction(&memory, &regs);
		if (vm::handle_instruction(instr, &memory, &regs)) break;
	};

	if (dump_registers) {
	    fmt::printfln("General purpose registers:")!;
	    fmt::printfln("\tR0 = 0x{:x}", regs[reg::R0]: u16)!;
	    fmt::printfln("\tR1 = 0x{:x}", regs[reg::R1]: u16)!;
	    fmt::printfln("\tR2 = 0x{:x}", regs[reg::R2]: u16)!;
	    fmt::printfln("\tR3 = 0x{:x}", regs[reg::R3]: u16)!;
	    fmt::printfln("\tR4 = 0x{:x}", regs[reg::R4]: u16)!;
	    fmt::printfln("\tR5 = 0x{:x}", regs[reg::R5]: u16)!;
	    fmt::printfln("\tR6 = 0x{:x}", regs[reg::R6]: u16)!;
	    fmt::printfln("\tR7 = 0x{:x}", regs[reg::R7]: u16)!;

		fmt::printfln("\nSpecial registers:")!;
        fmt::printfln("\tCOND = 0x{:b}", regs[reg::COND]: u16)!;
        fmt::printfln("\tPC   = 0x{:x}", regs[reg::PC]: u16)!;
	};
};

fn next_instruction(memory: *memory::memory, regs: *registers::registers) u16 = {
	let pc = regs[reg::PC];
	regs[reg::PC] += 1;
	return memory::read(memory, pc);
};
