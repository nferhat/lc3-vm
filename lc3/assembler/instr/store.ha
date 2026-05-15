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
