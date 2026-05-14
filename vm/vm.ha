use vm::memory;
use vm::memory::{word, memory};
use vm::registers;
use vm::registers::{registers, reg};
use vm::op;

use fmt;

// Available operations/instructions for the virtual machine.
export type opcode = enum uint {
    BR = 0,
    ADD,
    LD, 
    ST, 
    JSR,
    AND,
    LDR,
    STR,
    RTI,
    NOT,
    LDI,
    STI,
    JMP,
    RES,
    LEA,
    TRAP
};

/// Handle an operation on the registers.
export fn handle_instruction(
	instr: word,
	mem:   *memory,
	regs:  *registers,
) bool = {
	let opcode = (instr >> 12): opcode;
	switch (opcode) {
	// Bitwise arithmetic.
	case opcode::ADD => op::handle_bitwise(instr, regs, op::bitwise::ADD);
	case opcode::AND => op::handle_bitwise(instr, regs, op::bitwise::AND);
	case opcode::NOT => op::handle_bitwise(instr, regs, op::bitwise::NOT);
	// Load instructions
	case opcode::LDI => op::handle_ldi(instr, mem, regs);
	case opcode::LDR => op::handle_ldr(instr, mem, regs);
	case opcode::LD  => op::handle_ld( instr, mem, regs);
	case opcode::LEA => op::handle_lea(instr, regs);
	// Store instructions
	case opcode::ST  => op::handle_st( instr, mem, regs);
	case opcode::STR => op::handle_str(instr, mem, regs);
	case opcode::STI => op::handle_sti(instr, mem, regs);
	// Jump instructions
	case opcode::BR  => op::handle_br( instr, regs);
	case opcode::JMP => op::handle_jmp(instr, regs);
	case opcode::JSR => op::handle_jsr(instr, regs);
	// TRAP instruction
	case opcode::TRAP => return op::handle_trap(instr, mem, regs);

	case => fmt::fatalf("unhandled op: {}", opcode: u16);
	};

	return false;
};


