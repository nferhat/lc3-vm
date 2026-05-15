use lc3::{reg, cf, word};
use lc3::vm::registers;

// Update the `COND` register with the result of `w`.
export fn cf_update(regs: *registers::registers, r: reg) void = {
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
