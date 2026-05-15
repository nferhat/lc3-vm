use io;
use fmt;
use getopt;
use errors;
use fs;
use fs::{flag};
use os;
use strings;

use lc3::{reg, word};
use lc3::assembler;
use lc3::assembler::instr;

export fn main() void = {
    const cmd = getopt::parse(os::args, "LC-3 Assembler",
        ('o', "file", "output file"));
    defer getopt::finish(&cmd);

    let program = assembler::program {
        origin = 0x3000,
        instructions = [
            instr::add_instr {
                dr  = reg::R7,
                lhs = reg::R7,
                rhs = 7: word,
            },
            instr::add_instr {
                dr  = reg::R0,
                lhs = reg::R7,
                rhs = 14: word,
            },
            instr::not_instr {
                dr = reg::R0,
                sr = reg::R0,
            }
        ],
    };

    let program_bytes = assembler::assemble(program);

    const oflags = flag::WRONLY | flag::TRUNC;
	const file = match (os::create("out", 0o644, oflags)) {
	case let file: io::file =>
		yield file;
	case errors::noaccess =>
		fmt::fatalf("Error opening: Access denied.");
	case let err: fs::error =>
		fmt::fatalf("Error opening {}", fs::strerror(err));
	};
	defer io::close(file)!;

	match (io::write(file, program_bytes)) {
		case let err: io::error =>
			fmt::fatalf("Error writing file: {}", io::strerror(err));
		case let z: size =>
			assert(z == len(program_bytes), "Unexpected short write");
	};
};
