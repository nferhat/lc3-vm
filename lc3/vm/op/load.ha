use lc3::{word, reg};
use lc3::vm::registers::{registers};
use lc3::vm::memory::{memory};
use lc3::vm::memory;
use lc3::vm::utils;

// Handles an LDI instruction.
//
// It has the following static arguments:
// 1. Bits 15-12 => 1010 (opcode)
// 2. Bits 11-9  => destination register
// 3. Bits 8-0   => the address offset from the current PC.
export fn handle_ldi(instr: word, mem: *memory, regs: *registers) void = {
	const dr   = ((instr >> 9) & 0x7): reg;
	const off  = utils::sign_extend(instr & 0x1FF, 9);
	// In the reference, its M[M[PC + offset]], so we do a double load.
	const addr = memory::read(mem, (regs[reg::PC] + off): size): size;
	regs[dr]   = memory::read(mem, addr);
	utils::cf_update(regs, dr);
};

// Handles an LDI instruction.
//
// It has the following static arguments:
// 1. Bits 15-12 => 0110 (opcode)
// 2. Bits 11-9  => destination register
// 3. Bits 8-6   => base register
// 4. Bits 5-0   => offset
export fn handle_ldr(instr: word, mem: *memory, regs: *registers) void = {
	const dr  = ((instr >> 9) & 0x7): reg;
	const br  = ((instr >> 6) & 0x7): reg;
	const off = utils::sign_extend(instr & 0x3F, 6);
	regs[dr]  = memory::read(mem, (regs[br] + off): size);
	utils::cf_update(regs, dr);
};

// Handles a LEA instruction.
//
// It has the following static arguments:
// 1. Bits 15-12 => 0110 (opcode)
// 2. Bits 11-9  => destination register
// 3. Bits 8-0   => PC offset
export fn handle_lea(instr: word, regs: *registers) void = {
	const dr  = ((instr >> 9) & 0x7): reg;
	const off = utils::sign_extend(instr & 0x1FF, 9);
	regs[dr]  = (regs[reg::PC] + off): word;
	utils::cf_update(regs, dr);
};

// Handles a LD instruction.
//
// It has the following static arguments:
// 1. Bits 15-12 => 0010 (opcode)
// 2. Bits 11-9  => destination register
// 3. Bits 8-0   => PC offset
export fn handle_ld(instr: word, mem: *memory, regs: *registers) void = {
	const dr  = ((instr >> 9) & 0x7): reg;
	const off = utils::sign_extend(instr & 0x1FF, 9);
	regs[dr]  = memory::read(mem, (regs[reg::PC] + off): size);
	utils::cf_update(regs, dr);
};
