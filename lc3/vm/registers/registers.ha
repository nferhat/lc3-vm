use lc3;

// The type for storing register state.
export type registers = [lc3::reg::COUNT]lc3::word;

// Creates a new set of register state for a VM.
export fn new() registers = [0...];
