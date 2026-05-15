use lc3;
use fmt;

// An instruction of the assembler. These get encoded into [[lc3::word]]s
// and then saved in Big-Endian format onto the desired output.
export type instr = (bitwise_instr | jump_instr | load_instr | store_instr | trap_instr);

// A trap instruction.
export type trap_instr = struct {
    // The trapcode to use.
    code: u8,
};

export fn encode(instr: instr) lc3::word = {
    return match (instr) {
    case let bitwise: bitwise_instr =>
        yield encode_bitwise(bitwise);
    case let jump: jump_instr =>
        yield encode_jump(jump);
    case let load: load_instr =>
        yield encode_load(load);
    case let store: store_instr =>
        yield encode_store(store);
    case let trap: trap_instr =>
        let v: u16 = 0;
        v |= 0b1111 << 12;
        v |= trap.code;
        yield v;
    };
};
