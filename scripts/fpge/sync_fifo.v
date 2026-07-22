module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)(
    input clk_i,
    input rst_n,

    input wr_en_i,
    input [DATA_WIDTH - 1 : 0] wr_data_i,

    input rd_en_i,
    output reg [DATA_WIDTH - 1 : 0] rd_data_o,

    output empty_o,
    output full_o
);

    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);
    localparam CNT_WIDTH = $clog2(FIFO_DEPTH + 1);

    reg [DATA_WIDTH - 1 : 0] fifo_mem [0 : FIFO_DEPTH - 1];
    reg [ADDR_WIDTH - 1 : 0] wr_ptr;
    reg [ADDR_WIDTH - 1 : 0] rd_ptr;
    reg [CNT_WIDTH - 1 : 0] data_cnt;

    assign empty_o = (data_cnt == 0);
    assign full_o = (data_cnt == FIFO_DEPTH);

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            data_cnt <= 0;
            rd_data_o <= {DATA_WIDTH{1'b0}};
        end else begin
            case ({wr_en_i, rd_en_i})
                2'b10 : begin
                    if (!full_o) begin
                        fifo_mem[wr_ptr] <= wr_data_i;
                        data_cnt <= data_cnt + 1;

                        if (wr_ptr == FIFO_DEPTH - 1) begin
                            wr_ptr <= 0;
                        end else begin
                            wr_ptr <= wr_ptr + 1;
                        end
                    end
                end

                2'b01 : begin
                    if (!empty_o) begin
                        rd_data_o <= fifo_mem[rd_ptr];
                        data_cnt <= data_cnt - 1;

                        if (rd_ptr == FIFO_DEPTH - 1) begin
                            rd_ptr <= 0;
                        end else begin
                            rd_ptr <= rd_ptr + 1;
                        end
                    end
                end

                2'b11 : begin

                    if (!empty_o) begin
                        fifo_mem[wr_ptr] <= wr_data_i;
                        rd_data_o <= fifo_mem[rd_ptr];

                        if (wr_ptr == FIFO_DEPTH - 1) begin
                            wr_ptr <= 0;
                        end else begin
                            wr_ptr <= wr_ptr + 1;
                        end

                        if (rd_ptr == FIFO_DEPTH - 1) begin
                            rd_ptr <= 0;
                        end else begin
                            rd_ptr <= rd_ptr + 1;
                        end
                    end else begin
                        rd_data_o <= wr_data_i;
                    end

                end

                default : begin
                end
            endcase
        end
    end

endmodule
