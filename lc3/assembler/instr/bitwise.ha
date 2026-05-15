use lc3::{reg, word};

// A binary bitwise operation
export type bitwise_binary_op = struct {
    // The register to save the result in.
    dr:  reg,
    // The register to fetch the left hand side of the operation.
    lhs: reg,
    // The value to add, either from another register or an immediate value
    // encoded on 5 bits.
    rhs:  (reg | word),
};

// An add instruction, either a register-mode addition or a immediate mode
// add instruction
export type add_instr = bitwise_binary_op;
// An bitwise-and instruction, either a register-mode addition or a immediate mode
// add instruction
export type and_instr = bitwise_binary_op;

// A NOT instruction.
// ```
// NOT R0, R1
// ```
export type not_instr = struct {
    // The register to save the result in.
    dr: reg,
    // The register to fetch the left hand side of the operation.
    sr: reg,
};

// A bitwise operation.
export type bitwise_instr = (add_instr | and_instr | not_instr);

export fn encode_bitwise(instr: bitwise_instr) word = {
    let v: u16 = 0;
    match (instr) {
    case let not: not_instr =>
        v |=           0b1001 << 12;
        v |= (not.dr & 0b111) << 9;
        v |= (not.sr & 0b111) << 6;
        v |= 0b11111;

    case let add: add_instr =>
        v |=            0b0001 << 12;
        v |= (add.dr  & 0b111) << 9;
        v |= (add.lhs & 0b111) << 6;

        // Now encode the rhs.
        match (add.rhs) {
        case let r: reg =>
            v |= (r & 0b111);
        case let imm5: word =>
            // 6th bit means we are doing immediate mode.
            v |= 1 << 5;
            v |= (imm5 & 0b11111);
        };

    case let and: and_instr =>
        v |=            0b0101 << 12;
        v |= (and.dr  & 0b111) << 9;
        v |= (and.lhs & 0b111) << 6;

        // Now encode the rhs.
        match (and.rhs) {
        case let r: reg =>
            v |= (r & 0b111);
        case let imm5: word =>
            // 6th bit means we are doing immediate mode.
            v |= 1 << 5;
            v |= (imm5 & 0b11111);
        };
    };

    return v;
};
