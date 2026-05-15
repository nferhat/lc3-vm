use lc3::{word, reg};
use lc3::vm::registers::{registers};
use lc3::vm::utils;
use lc3::vm::memory;

// Handle a BR instruction.
//
// Arguments:
// 1. Bits 15-12 => 0000 (opcode)
// 2. Bits 11-9  => state of COND register to compare with
// 3. Bits 8-0   => off from PC.
export fn handle_br(instr: word, regs: *registers) void = {
	const cond = ((instr >> 9) & 0x7): word;
	const off  = utils::sign_extend(instr & 0x1FF, 9);
	if ((cond & regs[reg::COND]) > 0) regs[reg::PC] += off;
};

// Handle a JMP instruction
//
// Arguments:
// 1. Bits 15-12 => 1100 (opcode)
// 2. Bits 8-6   => base register to move to
export fn handle_jmp(instr: word, regs: *registers) void = {
	const br = ((instr >> 6) & 0x7): reg;
	regs[reg::PC] = regs[br];
};

// Handle a JSR instruction
//
// Arguments:
// 1. Bits 15-12 => 1100 (opcode)
// 2. Bit  11    => long flag
// 3. Bits 10-0  => offset from PC
export fn handle_jsr(instr: word, regs: *registers) void = {
	regs[reg::R7]  = regs[reg::PC]; // always save PC in R7

	const long_flag = ((instr >> 11) & 1) == 1;
	if (long_flag) {
		let off = utils::sign_extend(instr & 0x7FF, 11);
		regs[reg::PC] += off;
	} else {
		// Case for JSRR instruction
		let sr = ((instr >> 6) & 0x7): reg;
		regs[reg::PC] = regs[sr];
	};
};
