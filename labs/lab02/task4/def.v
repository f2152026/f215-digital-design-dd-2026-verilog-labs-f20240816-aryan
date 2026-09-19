// and_df.v
// Dataflow-style AND gate. The continuous assignment re-evaluates
// a & b immediately whenever a or b changes, then schedules the
// output update after a #5 delay. Correct: the value scheduled for
// the LHS is always the RHS value *at the time of the input change*,
// not a stale value read later.

module and_df (
    input  a, b,
    output y
);

assign #5 y = a & b;

endmodule