// 模組名稱：random_gen
// 功能：使用 5-bit LFSR (基於 CRC5) 產生一個 2-bit 的偽隨機數
module random_gen(
    input clk,
    input rst,
    input enable, // 當 enable 為 1 時，才產生新的隨機數
    
    output [1:0] random_out // 2-bit 的隨機數輸出 (0~3)
    );

    // 1. 宣告 LFSR 核心的 5-bit 暫存器   
    reg [4:0] lfsr_reg;
    
    // 2. 宣告一個 wire 來儲存回饋位元 (feedback bit) 的計算結果
    wire feedback_bit;
    
    // 3. 描述回饋位元的 "組合邏輯"
    //    使用 assign 來描述一個組合邏輯電路 (一個 XOR 閘)
    //    回饋線路來自第 5 位元(lfsr_reg[4]) 和第 2 位元(lfsr_reg[1])
    //    ^ 是 Verilog 中的 XOR 運算子
    assign feedback_bit = lfsr_reg[4] ^ lfsr_reg[1];
    
    // 4. 描述 LFSR 暫存器的 "循序邏輯"
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 在重置時，給予一個 "非零" 的初始值 (種子)
            lfsr_reg <= 5'b11111;
        end
        else begin
            // 只有在 enable 為 1 的時候，才進行移位更新
            if (enable) begin
                // {a, b} 是串接運算子 (Concatenation)
                // {lfsr_reg[3:0], feedback_bit} 的意思是：
                // 把 lfsr_reg 的 bit 3 到 0 作為新的 bit 4 到 1，
                // 再把 feedback_bit 作為新的 bit 0。
                // 這就完成了一次「左移 + 填入新位元」的操作。
                lfsr_reg <= {lfsr_reg[3:0], feedback_bit};
            end
            // 如果 enable 不為 1，lfsr_reg 不會被賦值，所以會保持原值不變
        end
    end
    
    // 5. 描述輸出邏輯
    //    直接從 5-bit 的 LFSR 中取出低 2-bit 作為我們的隨機數輸出
    assign random_out = lfsr_reg[1:0];

endmodule