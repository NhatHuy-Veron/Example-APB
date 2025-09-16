module apb_slave (
    input  logic        PCLK,
    input  logic        PRESETn,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic        PWRITE,
    input  logic [7:0]  PADDR,
    input  logic [31:0] PWDATA,
    output logic [31:0] PRDATA
);

    // 256-entry memory (8-bit address)
    logic [31:0] mem [0:255];

    // APB transfer detection
    wire apb_transfer = PSEL && PENABLE;

    // Read/Write logic
    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            // Reset memory to 0
            for (int i = 0; i < 256; i++) begin
                mem[i] <= 32'h0;
            end
            PRDATA <= 32'h0;
        end else begin
            if (apb_transfer) begin
                if (PWRITE) begin
                    // Write operation
                    mem[PADDR] <= PWDATA;
                end else begin
                    // Read operation
                    PRDATA <= mem[PADDR];
                end
            end
        end
    end

endmodule