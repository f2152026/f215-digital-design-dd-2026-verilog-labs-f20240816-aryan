// and_beh_intra.v
// Behavioral AND gate using an intra-assignment delay. The RHS
// (a & b) is evaluated IMMEDIATELY when the always block triggers
// (i.e. using the input values at the moment of the change), and
// only the assignment of that already-computed value to y is
// delayed by 5 time units. This correctly reflects each input
// transition even when inputs toggle faster than the delay.

module and_beh_intra (
    input      a, b,
    output reg y
);

always @(a or b) begin
    y = #5 (a & b);   // a & b sampled NOW; only the write to y is delayed
end

endmodule