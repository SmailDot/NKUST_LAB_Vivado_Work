// 模組名稱：pwm_gen
// 功能：根據 4-bit 輸入，產生對應工作週期的 PWM 波形
// 日期：2025-09-23
`timescale 1ns / 1ps

module pwm_gen(
    input clk,
    input rst,
    input [3:0] duty_in, // 輸入的工作週期值 (0~15)
    
    output reg pwm_out   // 1-bit 的 PWM 波形輸出
    );

    // ------------------- 內部信號宣告 -------------------

    // 1. 為了方便計算百分比，我們讓總週期為 100 個時脈。
    //    所以需要一個能數到 99 的計數器。
    //    2^6 = 64 (不夠), 2^7 = 128 (足夠)，所以宣告為 7-bit。
    reg [6:0] counter_reg;
    
    // 2. 一個 wire 來儲存工作週期的閥值 (threshold)。
    //    duty_in (0~15) * 10 => 最大值 150。
    //    2^7 = 128 (不夠), 2^8 = 256 (足夠)，所以宣告為 8-bit。
    wire [7:0] threshold;
    
    // ------------------- 電路行為描述 -------------------

    // 3. 組合邏輯：計算閥值
    //    使用 assign 來描述一個純組合邏輯電路 (在這裡是一個乘法器)。
    //    它的意思是 threshold 的值 "永遠等於" duty_in 的值乘以 10。
    assign threshold = duty_in * 10;
    
    // 4. 循序邏輯：描述計數器和 PWM 輸出的行為
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // --- 重置邏輯 ---
            // 當 rst 為 1 時，強制將計數器歸零，並讓 PWM 輸出為 0。
            counter_reg <= 7'd0;
            pwm_out     <= 1'b0;
        end
        else begin
            // --- 計數器邏輯 ---
            // 在每一個時脈上升緣，檢查計數器的值。
            // 如果計數器已經數到 99 (代表一個 PWM 週期結束)...
            if (counter_reg == 7'd99) begin
                counter_reg <= 7'd0; // ...就將計數器歸零，準備開始下一個週期。
            end
            else begin
                counter_reg <= counter_reg + 1; // ...否則，就將計數器加 1。
            end
            
            // --- PWM 輸出比較邏輯 ---
            // 這個邏輯與上面的計數器邏輯是 "並行" 發生的。
            // 在每一個時脈上升緣，"同時" 檢查計數器的值。
            // 如果計數器的值小於我們計算出的閥值...
            if (counter_reg < threshold) begin
                pwm_out <= 1'b1; // ...輸出就為 1 (高電位)。
            end
            else begin
                pwm_out <= 1'b0; // ...否則，輸出就為 0 (低電位)。
            end
        end
    end

endmodule