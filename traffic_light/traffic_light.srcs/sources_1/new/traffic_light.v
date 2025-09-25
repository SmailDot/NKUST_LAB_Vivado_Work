// 模組名稱：traffic_light
// 功能：一個經典的綠、黃、紅燈循環的交通號誌 FSM
//module 算是一種宣告語言 告訴Vivado說 現在要創立一個新的模組 名字是什麼
module traffic_light(
    input clk, //這邊定義了兩個輸入端 一個叫做CLK 我們當作時脈
    input rst, //這邊定義的RST我們當作重置信號
    
    // 使用 3-bit 輸出來代表三種燈號
    // GREEN : 3'b001
    // YELLOW: 3'b010
    // RED   : 3'b100
    output reg [2:0] light_out //這裡用一個範圍 需要3-BIT 所以是2、1、0 共三個，reg是一個使用的conmment
    ); 

    // 1. 定義 FSM 的狀態
    parameter S_GREEN  = 2'b00;
    parameter S_YELLOW = 2'b01;
    parameter S_RED    = 2'b10;

    // 2. 定義每個狀態需要持續的時脈週期數
    //    減 1 是因為我們從 0 開始數 (0~7 共 8 個數)
    parameter GREEN_TIME  = 8 - 1;
    parameter YELLOW_TIME = 2 - 1;
    parameter RED_TIME    = 10 - 1;

    // 3. 宣告 FSM 和計時器需要的暫存器
    reg [1:0] state_reg; // 儲存 FSM 的當前狀態 可以當作 FSM 的「狀態記憶體」
    reg [3:0] count_reg; // 計時器，因為最大要數到 10，所以需要 4-bit 2的4次方 

    // 4. 核心邏輯區塊  posedge (上升緣) 或 negedge (下降緣)
    always @(posedge clk or posedge rst) begin //always 算是用來描述 "循序邏輯"使用的指令 @(...)裡面 白話一點就是再說 當 clk 或 rst 有上升信號產生時 才執行我們下面寫的begin to end 的程式邏輯
        if (rst) begin
            // --- 重置邏輯 ---
            // 如果重置，強制回到綠燈狀態，計時器和輸出都歸零
            state_reg <= S_GREEN;  //這邊 就是當觸發"rst"會強制執行 回到"原點"的狀態
            count_reg <= 4'd0;
            light_out <= 3'b001; // 重置後直接亮綠燈
        end
        else begin
            // --- FSM 狀態轉換邏輯 ---
            case (state_reg)
                S_GREEN: begin
                    light_out <= 3'b001; // 在綠燈狀態，持續輸出綠燈信號
                    // 檢查計時器是否到達設定的時間
                    if (count_reg == GREEN_TIME) begin
                        state_reg <= S_YELLOW; // 時間到，切換到黃燈狀態
                        count_reg <= 4'd0;     // 計時器歸零，給下個狀態用
                    end
                    else begin
                        count_reg <= count_reg + 1; // 時間未到，計時器加 1
                    end
                end
                
                S_YELLOW: begin
                    light_out <= 3'b010; // 在黃燈狀態，持續輸出黃燈信號
                    if (count_reg == YELLOW_TIME) begin
                        state_reg <= S_RED;    // 時間到，切換到紅燈狀態
                        count_reg <= 4'd0;     // 計時器歸零
                    end
                    else begin
                        count_reg <= count_reg + 1; // 時間未到，計時器加 1
                    end
                end
                
                S_RED: begin
                    light_out <= 3'b100; // 在紅燈狀態，持續輸出紅燈信號
                    if (count_reg == RED_TIME) begin
                        state_reg <= S_GREEN;  // 時間到，切換回綠燈狀態，完成循環
                        count_reg <= 4'd0;     // 計時器歸零
                    end
                    else begin
                        count_reg <= count_reg + 1; // 時間未到，計時器加 1
                    end
                end

                default: begin
                    // 如果 FSM 意外進入未知狀態，強制它回到綠燈狀態
                    state_reg <= S_GREEN;
                    count_reg <= 4'd0;
                    light_out <= 3'b001;
                end
            endcase
        end
    end

endmodule