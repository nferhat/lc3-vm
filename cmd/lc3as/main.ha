use io;
use fmt;
use path;
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
        ('o', "file", "output file"),
        "<input>");
    defer getopt::finish(&cmd);

    let output_path = "";
    for (let opt .. cmd.opts) {
        switch (opt.0) {
        case 'o' =>
            output_path = opt.1;
        case => abort();
        };
    };

    if (len(cmd.args) != 1) {
        getopt::printhelp(os::stdout, os::args[0], cmd.help)!;
        os::exit(os::status::FAILURE);
    };

    let input_path = cmd.args[0];
    if (output_path == "") {
        // Use input without extension.
        let buf = path::init(input_path)!;
        path::pop_ext(&buf);
        match (path::push_ext(&buf, "obj")) {
        case let p: str =>
            output_path = p;
        case let e: path::error =>
            fmt::fatalf("Failed to compute output path: {}",
                path::strerror(e));
        };
    };

    // The assembler logic is really simple
    //
    // 1. Read the input file
    // 2. Lex it into a list of tokens
    // 3. Parse it into an AST. This is also the step where static memory
    //    allocations are figured out (for example if you have a .stringz
    //    defined somewhere)
    // 4. Turn the AST into a [[assembler::program]]
    // 5. Assemble/encode this program into a BE binary.

    let program = assembler::program {
        origin = 0x3000,
        ...
    };

    let program_bytes = assembler::assemble(program);

    const oflags = flag::WRONLY | flag::TRUNC;
	const file = match (os::create(output_path, 0o644, oflags)) {
	case let file: io::file =>
		yield file;
	case errors::noaccess =>
		fmt::fatalf("Error opening {}: Access denied.", output_path);
	case let err: fs::error =>
		fmt::fatalf("Error opening {}: {}",
		    output_path, fs::strerror(err));
	};
	defer io::close(file)!;

	match (io::write(file, program_bytes)) {
		case let err: io::error =>
			fmt::fatalf("Error writing file: {}", io::strerror(err));
		case let z: size =>
			assert(z == len(program_bytes), "Unexpected short write");
	};
};
