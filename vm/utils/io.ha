use vm::memory::{word};

use bufio::{flush};
use io::{read, write, error};
use os::{stdout, stdin};

// `getchar()` implementation using hare's I/O primitives
export fn getchar() word = {
	let char = 0u8;
	read(stdin, &char: *[1]u8)!;
	return char: word;
};

// `putc()` implementation using hare's I/O primitives
export fn putchar(char: word) (size | error) = {
    let ch = (char: u16) & 0xFF; // limit to u8 range
    let res = write(stdout, [char: u8])?;
    flush(stdout)?;
    return res;
};
