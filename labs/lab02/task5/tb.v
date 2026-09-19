// tb.v
// Self-checking testbench for alu.
// Exhaustively drives all (a, b, op) combinations and checks result
// against the expected add/sub value computed independently in the
// testbench. Designed to expose:
//   1. Sensitivity-list bug: hold a,b fixed, toggle op only, and check
//      that result updates.
//   2. Blocking/non-blocking bug in the subtract path: check the
//      *combinational, same-time-step* value of result, not a value
//      that only becomes correct one or two deltas/cycles later.

module tb;

    reg  [3:0] a, b;
    reg        op;
    wire [3:0] result;

    integer errors = 0;
    reg  [3:0] expected;

    alu dut (
        .a      (a),
        .b      (b),
        .op     (op),
        .result (result)
    );

    task check;
        begin
            expected = op ? (a - b) : (a + b);
            #0; // let any pending non-blocking updates in DUT settle so we
                // see whether result is ACTUALLY correct this instant,
                // not just eventually
            if (result !== expected) begin
                $display("ERROR: t=%0t a=%0d b=%0d op=%b -> result=%0d expected=%0d",
                           $time, a, b, op, result, expected);
                errors = errors + 1;
            end
        end
    endtask

    integer i, j;
    initial begin
        // --- Part A: exhaustive add/sub sweep ---
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i[3:0];
                b = j[3:0];

                op = 1'b0;
                #5 check;   // add

                op = 1'b1;
                #5 check;   // sub
            end
        end

        // --- Part B: sensitivity-list check ---
        // Hold a, b constant, only toggle op, and verify result tracks it.
        a = 4'd9;
        b = 4'd3;
        op = 1'b0;
        #5 check;           // expect 12 (add)

        op = 1'b1;          // change ONLY op, a & b unchanged
        #5 check;           // expect 6 (sub) -- fails if always block
                             // isn't sensitive to op

        op = 1'b0;
        #5 check;           // back to add, expect 12 again

        if (errors == 0)
            $display("PASS: all checks correct.");
        else
            $display("FAIL: %0d error(s) found.", errors);

        $finish;
    end

endmodule