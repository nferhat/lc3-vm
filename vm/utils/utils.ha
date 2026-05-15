use vm::registers::{reg, registers};
use vm::memory::{word};

use bufio;
use io;
use os;
use fs;

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
