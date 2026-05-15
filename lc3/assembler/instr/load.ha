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
