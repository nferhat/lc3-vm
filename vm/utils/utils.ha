use vm::registers::{reg, registers};
use vm::memory::{word};

use bufio;
use io;
use os;
use fs;

// Condition flags.
export type cf = enum uint {
	POS  = 1 << 0,
	ZERO = 1 << 1,
	NEG  = 1 << 2,
};

// Handle sign extension for words.
//
// A lot of instructions take immediate arguments, for example the add instruction
// ```
// ADD R0 R0 <imm5>
// ```
// Where <imm5> is a value with a size of five bits.
//
// When converting such value into a proper `memory::word`, we have to take extra caution if we are
// working with a signed integer. If we extend for example `11111` (which is -16 in signed mode),
// the result would be `000...11111` (which is equal to 31).
//
// The correct behavior is to transform this into `1000000000001111`, which is a -16
export fn sign_extend(x: word, bit_count: size) word = {
	if ((x >> (bit_count - 1)) == 1) {
		x |= 0xFFFF << bit_count: word;
	};

	return x;
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

// `getchar()` implementation using hare's I/O primitives
export fn getchar() word = {
	let char = 0u8;
	io::read(os::stdin, &char: *[1]u8)!;
	return char: word;
};

// `putc()` implementation using hare's I/O primitives
export fn putchar(char: word) (size | io::error) = {
    let res = io::write(os::stdout_file, [char: u8])?;
    bufio::flush(os::stdout)?;
    return res;
};
