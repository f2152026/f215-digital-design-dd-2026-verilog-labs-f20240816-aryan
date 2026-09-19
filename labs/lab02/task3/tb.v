module comp2_tb;

    reg  [1:0] A, B;
    wire       GT, LT, EQ;

    integer i, j;
    integer errors = 0;

    comp2 dut (
        .A  (A),
        .B  (B),
        .GT (GT),
        .LT (LT),
        .EQ (EQ)
    );

    task check;
        integer onehot_count;
        begin
            onehot_count = GT + LT + EQ;

            if (onehot_count != 1) begin
                $display("ERROR: A=%0d B=%0d -> GT=%b LT=%b EQ=%b (not one-hot, count=%0d)",
                          A, B, GT, LT, EQ, onehot_count);
                errors = errors + 1;
            end
            else if (A > B && !GT) begin
                $display("ERROR: A=%0d B=%0d -> expected GT=1, got GT=%b LT=%b EQ=%b",
                          A, B, GT, LT, EQ);
                errors = errors + 1;
            end
            else if (A < B && !LT) begin
                $display("ERROR: A=%0d B=%0d -> expected LT=1, got GT=%b LT=%b EQ=%b",
                          A, B, GT, LT, EQ);
                errors = errors + 1;
            end
            else if (A == B && !EQ) begin
                $display("ERROR: A=%0d B=%0d -> expected EQ=1, got GT=%b LT=%b EQ=%b",
                          A, B, GT, LT, EQ);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                A = i[1:0];
                B = j[1:0];
                #1;
                check;
            end
        end

        if (errors == 0)
            $display("PASS: all 16 combinations correct.");
        else
            $display("FAIL: %0d error(s) found.", errors);

        $finish;
    end

endmodule