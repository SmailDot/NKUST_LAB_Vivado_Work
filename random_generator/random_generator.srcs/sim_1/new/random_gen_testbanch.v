`timescale 1ns / 1ps

module random_gen_tb;

    // ���͵� DUT ���T��
    reg clk;
    reg rst;
    reg en; // enable
    integer i;
    
    // �q DUT �����T��
    wire [1:0] rand_num;
    
    // ��Ҥ� DUT
    random_gen DUT (
        .clk(clk),
        .rst(rst),
        .enable(en),
        .random_out(rand_num)
    );
    
    // ���ͮɯ�
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns �g��
    end
    
    // ���ʹ��լy�{
    initial begin
        // 1. ���m
        rst = 1;
        en = 0;
        #20;
        rst = 0;
        
        // 2. �ھ��D�حn�D�A�s�򲣥� 10 ���H����
        //    �ڭ̨ϥ� for �j����� enable �H��Ĳ�o 10 ��
        
        for (i = 0; i < 10; i = i + 1) begin
            en = 1; // �԰� enable
            #10;    // ����@�Ӯɯ߶g��
        end
        
        // 3. ��������
        en = 0; // �ԧC enable
        #50;
        
        $finish;
    end

endmodule