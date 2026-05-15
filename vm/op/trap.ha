use vm::memory;
use vm::memory::{word, memory};
use vm::registers::{registers, reg};
use vm::utils::{getchar, putchar, cf_update};

use strings;
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
			let char = memory::read(mem, addr: size);
			if (char == 0) break;
			putchar(char)!;
			addr += 1;
		};

	case trapcode::GETC =>
		regs[reg::R0] = getchar();
		cf_update(regs, reg::R0);
	case trapcode::IN =>
		// The difference between GETC and IN is that GETC doesn't print the character
		// that was asked for. IN prints it back out.
		regs[reg::R0] = getchar();
		putchar(regs[reg::R0])!;
		cf_update(regs, reg::R0);

	case trapcode::OUT => putchar(regs[reg::R0])!;

	case trapcode::PUTSP =>
		let addr = regs[reg::R0];
		// FIXME: This can loop until the end of memory like this.
		for (true) {
			let value = memory::read(mem, addr: size);
			if (value == 0) break;
			// Each word (u16) get split into two chars (2x u8)
			putchar(value & 0xFF)!;
			putchar((value >> 8) & 0xFF)!;
			addr += 1;
		};

	case trapcode::HALT =>
		return true;
	};

	return false;
};
