 use endian;
 use fmt;
 use lc3::assembler::instr::{instr, encode};

// A single LC-3 program representation. You should use [[encode]] in order to
// turn it into bytes that can be written into an OBJ file.
export type program = struct {
    // The origin of this program, IE where to load its instructions
    origin: u16,
    // The instructions of this program
    instructions: []instr,
};


// Encodes the given program into a valid LC-3 binary.
export fn assemble(program: program) []u8 = {
    let bytes: []u8 = [];

    // First write the origin of the program.
    let origin_bytes: [2]u8 = [0...];
    endian::beputu16(origin_bytes, program.origin);
    // NOTE: Since we are encoding in Big-Endian second byte comes first.
    append(bytes, origin_bytes[0])!;
    append(bytes, origin_bytes[1])!;

    for (let instr .. program.instructions) {
        let instr_bytes: [2]u8 = [0...];
        endian::beputu16(instr_bytes, encode(instr));
        // NOTE: Since we are encoding in Big-Endian second byte comes first.
        append(bytes, instr_bytes[0])!;
        append(bytes, instr_bytes[1])!;
    };

    return bytes;
};
