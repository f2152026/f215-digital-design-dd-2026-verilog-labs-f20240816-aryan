// and_beh_before.v
// Behavioral AND gate with the delay placed BEFORE the assignment.
// BUG: the always block wakes up on a change of a/b, waits 5 time
// units, and only THEN reads a and b to compute y. If a or b change
// again during that #5 wait, this reads the NEW (updated) values
// instead of the values that were present at the moment the block
// triggered -- i.e. it uses stale timing / wrong-sample values and
// can miss or corrupt transitions when inputs toggle faster than
// the delay.

module and_beh_before (
    input      a, b,
    output reg y
);

always @(a or b) begin
    #5;
    y = a & b;   // a, b sampled AFTER the delay -- may already have changed
end

endmodule