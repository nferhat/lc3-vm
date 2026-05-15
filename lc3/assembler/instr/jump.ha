use lc3::{reg, word};

// BR instruction
export type br_instr = struct {
    // The state of the cond register to compare with,
    cond: word,
    // The offset to add to the PC, encoded on 9 bits
    off: word,
};

// JMP instruction.
export type jmp_instr = struct {
    // The base register containing the new value of the PC.
    br: reg,
};

// JSR instruction, in register/normal mode.
export type jsr_reg_instr = struct {
    // The register containing the new value of the PC.
    sr: reg,
};

// JSR instruction, in long mode.
export type jsr_long_instr = struct {
    // The offset to add to the PC, encoded on 11 bits.
    off: word,
};

// JSR instruction, either in long mode or regular mode.
export type jsr_instr = (jsr_long_instr | jsr_reg_instr);

export type jump_instr = (jsr_instr | jmp_instr | br_instr);

export fn encode_jump(instr: jump_instr) word = {
    let v: u16 = 0;

    match (instr) {
    case let br: br_instr =>
        v |=            0b0000 << 12; // just to be consistent.
        v |= (br.cond & 0b111) << 9;
        v |= (br.off  & 0x1FF);
    case let jmp: jmp_instr =>
        v |=           0b1100 << 12;
        v |= (jmp.br & 0b111) << 6;

    case let jsr: jsr_instr =>
        v |= 0b0100 << 12;
        match (jsr) {
        case let long: jsr_long_instr =>
            v |= 1 << 11;
            v |= long.off & 0x7FF;
        case let reg: jsr_reg_instr =>
            v |= (reg.sr & 0b111) << 6;
        };
    };

   return v;
};
