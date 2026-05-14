use vm::memory;
use vm::memory::{word, memory};
use vm::registers::{registers, reg};
use vm::utils::{getchar, putchar, cf_update};

use bufio::{flush};
use strings;
use fmt;
use fs;
use io;
use os;

// Available trap subroutine codes
type trapcode = enum uint {
    GETC  = 0x20, // get character from keyboard, not echoed onto the terminal
    OUT   = 0x21, // output a character
    PUTS  = 0x22, // output a word string
    IN    = 0x23, // get character from keyboard, echoed onto the terminal
    PUTSP = 0x24, // output a byte string
    HALT  = 0x25, // halt the program
};

export fn handle_trap(instr: word, mem: *memory, regs: *registers) bool = {
	regs[reg::R7] = regs[reg::PC];
	const code = (instr & 0xFF): trapcode;
	switch (code) {
	case trapcode::PUTS =>
		let addr = regs[reg::R0];
		for (true) {
			// FIXME: This can loop until the end of memory like this.
			let char = memory::read(mem, addr: size): u8;
			if (char == 0) break;
			io::write(os::stdout, [char])!;
			flush(os::stdout)!;
			addr += 1;
		};

	case trapcode::GETC =>
		regs[reg::R0] = getchar()!: u8: u16;
		cf_update(regs, reg::R0);

	case trapcode::OUT =>
		fmt::printf(strings::fromutf8([regs[reg::R0]: u16: u8])!)!;
		flush(os::stdout)!;

	case trapcode::IN =>
		// We need to prompt for a single character.
		regs[reg::R0] = getchar()!: u8: u16;
		putchar(regs[reg::R0]: u8)!;
		flush(os::stdout)!;
		cf_update(regs, reg::R0);

	case trapcode::PUTSP =>
		let addr = regs[reg::R0];
		// FIXME: This can loop until the end of memory like this.
		for (true) {
			// Each word (u16) get split into two chars (2x u8)
			let value = memory::read(mem, addr: size);
			if (value == 0) break;

			let c1 = (value & 0xFF): u8;
			let c2 = ((value >> 8) & 0xFF): u8;
			io::write(os::stdout, [c1, c2])!;
			flush(os::stdout)!;

			addr += 1;
		};

	case trapcode::HALT =>
		return true;
	};

	return false;
};

