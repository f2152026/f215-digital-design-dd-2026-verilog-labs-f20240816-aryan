// tb.v
// Starter testbench template -- YOU complete this file.


module tb;

  // TODO: declare the inputs and outputs
  localparam WIDTH = 8;
  localparam DEPTH = 4;
  localparam SELW  = $clog2(DEPTH);
   // sel is driven procedurally -> variable
  reg  [SELW-1:0]  t_sel;
  // dout is driven by the instance -> net
  wire [WIDTH-1:0] t_dout;

  integer k;

  // TODO: instantiate DUT here
   lut #(
    .WIDTH (WIDTH),
    .DEPTH (DEPTH)
  ) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // TODO: apply different input combinations
   for (k = 0; k < DEPTH; k = k + 1) begin
      t_sel = k[SELW-1:0];
      #5;
    end
    $finish ;
  

  end

  initial
    $monitor($time, " sel=%0d | dout=%0d (0x%0h)", t_sel, t_dout, t_dout); // change as required

endmodule
