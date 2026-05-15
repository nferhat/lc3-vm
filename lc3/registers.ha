// All the named registers in the LC3 architecture.
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
