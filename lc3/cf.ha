// Condition flags.
//
// These are used to mark the result of the last instruction.
export type cf = enum u16 {
	POS  = 1 << 0,
	// The result is zero.
	ZERO = 1 << 1,
	// The result is negative.
	NEG  = 1 << 2,
};
