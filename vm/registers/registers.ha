use vm::memory::{word};

// All the named registers in the LC3 architecture.
// These don't include named registers, which are handled in memory.ha
export type reg = enum u16 {
	// General purpose registers from R0-7
	R0 = 0,
	R1,
	R2,
	R3,
	R4,
	R5,
	R6,
	R7,

	// Program counter.
	PC,
	// Condition register. See opcode.ha for the `cf` type
	COND,

	// Count the amount of register
	COUNT,
};

// The type for storing register state.
export type registers = [reg::COUNT]word;

// Creates a new set of register state for a VM.
export fn new() registers = [0...];
