use lc3::{reg, word};

// ST instruction.
export type st_instr = struct {
    // The register to read the value from.
    sr: reg,
    // The offset from the PC to save the value into, encoded on 9 bits.
    off: word,
};

// STI instruction.
export type sti_instr = struct {
    // The register to read the value from.
    sr: reg,
    // The offset from the PC from which to load the address of the value to
    // write, encoded on 9 bits.
    off: word,
};

// STR instruction.
export type str_instr = struct {
    // The register to read the value from.
    sr: reg,
    // The base register from which to read the address base.
    br: reg,
    // The offset to add onto the base register's value, encoded on 6 bits.
    off: word,
};

export type store_instr = (str_instr | sti_instr | st_instr);

export fn encode_store(instr: store_instr) word = {
    let v: u16 = 0;
    match (instr) {
    case let st: st_instr =>
        v |=           0b0011 << 12;  // ST opcode
        v |= (st.sr  & 0b111) << 9;
        v |= (st.off & 0x1FF);
    case let str_: str_instr =>
        v |=            0b0111 << 12;  // STR opcode
        v |= (str_.sr  & 0b111) << 9;
        v |= (str_.br  & 0b111) << 6;
        v |= (str_.off & 0x3F);
    case let sti: sti_instr =>
        v |=            0b1011 << 12;  // STI opcode
        v |= (sti.sr  & 0b111) << 9;
        v |= (sti.off & 0x1FF);
    };

    return v;
};
