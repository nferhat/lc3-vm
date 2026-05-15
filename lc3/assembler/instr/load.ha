use lc3::{reg, word};

// LDI instruction.
export type ldi_instr = struct {
    // The destination register to load the value into.
    dr: reg,
    // The offset from the PC from which to load the address of the value to
    // load, encoded on 9 bits.
    off: word
};

// LDR instruction.
export type ldr_instr = struct {
    // The destination register to load the value into.
    dr: reg,
    // The base register from which to read the address base.
    br: reg,
    // The offset to add onto the base register's value, encoded on 6 bits.
    off: word,
};

// LEA instruction.
export type lea_instr = struct {
    // The destination register to load the value into.
    dr: reg,
    // The offset of the label's address to load into the DR, encoded on 9 bits.
    off: word
};

// LD instruction.
export type ld_instr = struct {
    // The destination register to load the value into.
    dr: reg,
    // The address offset from the PC to load the value from.
    off: word,
};

export type load_instr = (ld_instr | ldr_instr | lea_instr | ldi_instr);

export fn encode_load(instr: load_instr) word = {
    let v: u16 = 0;
    match (instr) {
    case let ld: ld_instr =>
        v |=           0b0010 << 12;
        v |= (ld.dr  & 0b111) << 9;
        v |= (ld.off & 0x1FF);
    case let ldr: ldr_instr =>
        v |=           0b0110 << 12;
        v |= (ldr.dr & 0b111) << 9;
        v |= (ldr.br & 0b111) << 6;
        v |= (ldr.off & 0x3F);
    case let lea: lea_instr =>
        v |=            0b1110 << 12;
        v |= (lea.dr  & 0b111) << 9;
        v |= (lea.off & 0x1FF);
    case let ldi: ldi_instr =>
        v |=            0b1010 << 12;
        v |= (ldi.dr  & 0b111) << 9;
        v |= (ldi.off & 0x1FF);
    };

    return v;
};
