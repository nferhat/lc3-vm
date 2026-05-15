use lc3;
use lc3::vm::registers;
use lc3::vm::utils;

// Bitwise operation type.
export type bitwise = enum {
	AND,
	ADD,
	NOT,
};

// Handles a bitwise arithmetic instruction.
//
// It has the following static arguments:
// 1. Bits 15-12 => 0001 (opcode)
// 2. Bits 11-9  => destination register
// 3. Bits 8-6   => source register 1
// 4. Bit 5      => mode (0 = register mode, 1 = immediate mode)
//
// If in immediate mode, bits 4-0 represent the immediate/inline value to use.
// if in register mode, bits 2-0 represent the source register two.
export fn handle_bitwise(instr: lc3::word, regs: *registers::registers, kind: bitwise) void = {
	let dr  = ((instr >> 9) & 0x7): lc3::reg;
	let sr1 = ((instr >> 6) & 0x7): lc3::reg;
	let lhs = regs[sr1];

	let immediate = ((instr >> 5) & 0x1) == 1;
	let rhs = if (immediate) {
		let imm5 = utils::sign_extend(instr & 0x1F, 5);
		yield imm5;
	} else {
		let sr2 = instr & 0x7;
		yield regs[sr2];
	};

	regs[dr] = switch (kind) {
	case bitwise::AND => yield lhs & rhs;
	case bitwise::ADD => yield lhs + rhs;
	case bitwise::NOT => yield ~lhs;
	};

	utils::cf_update(regs, dr);
};
