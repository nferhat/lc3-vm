use vm::memory::{word};
use vm::registers::{registers, reg};

// Condition flags.
export type cf = enum u16 {
	POS  = 1 << 0,
	ZERO = 1 << 1,
	NEG  = 1 << 2,
};


// Update the `COND` register with the result of `w`.
export fn cf_update(regs: *registers, r: reg) void = {
	let res = if (regs[r] == 0) {
		yield cf::ZERO;
	} else if ((regs[r] >> 15) == 1) {
		// Negative values are signed.
		yield cf::NEG;
	} else {
		yield cf::POS;
	};

	regs[reg::COND] = res: word;
};
