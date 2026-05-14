use vm::memory;
use vm::memory::{word, memory};
use vm::registers::{registers, reg};
use vm::utils;

// Handles a ST instruction
//
// Arguments:
// 1. Bits 15-12 => 0011 (opcode)
// 2. Bits 11-9  => source register
// 3. Bits 8-0   => offset from PC.
export fn handle_st(instr: word, mem: *memory, regs: *registers) void = {
	const sr   = ((instr >> 9) & 0x7): reg;
	const off  = utils::sign_extend(instr & 0x1FF, 9);
	const addr = (regs[reg::PC] + off): size;
	memory::write(mem, addr, regs[sr]);
};

// Handles a STI instruction
//
// Arguments:
// 1. Bits 15-12 => 0011 (opcode)
// 2. Bits 11-9  => source register
// 3. Bits 8-0   => offset from PC.
export fn handle_sti(instr: word, mem: *memory, regs: *registers) void = {
	const sr    = ((instr >> 9) & 0x7): reg;
	const off   = utils::sign_extend(instr & 0x1FF, 9);
	const addr  = (regs[reg::PC] + off): size;
	const value = memory::read(mem, addr);
	memory::write(mem, addr, value);
};

// Handles a STR instruction
//
// Arguments:
// 1. Bits 15-12 => 0011 (opcode)
// 2. Bits 11-9  => source register
// 3. Bits 8-6   => base register
// 4. Bits 5-0   => offset from PC.
export fn handle_str(instr: word, mem: *memory, regs: *registers) void = {
	const sr   = ((instr >> 9) & 0x7): reg;
	const br   = ((instr >> 6) & 0x7): reg;
	const off  = utils::sign_extend(instr & 0x3F, 6);
	const addr = (regs[br] + off): size;
	memory::write(mem, addr, sr);

};
