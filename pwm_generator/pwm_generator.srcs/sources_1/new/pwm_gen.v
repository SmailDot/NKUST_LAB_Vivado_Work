// �ҲզW�١Gpwm_gen
// �\��G�ھ� 4-bit ��J�A���͹����u�@�g���� PWM �i��
// ����G2025-09-23
`timescale 1ns / 1ps

module pwm_gen(
    input clk,
    input rst,
    input [3:0] duty_in, // ��J���u�@�g���� (0~15)
    
    output reg pwm_out   // 1-bit �� PWM �i�ο�X
    );

    // ------------------- �����H���ŧi -------------------

    // 1. ���F��K�p��ʤ���A�ڭ����`�g���� 100 �ӮɯߡC
    //    �ҥH�ݭn�@�ӯ�ƨ� 99 ���p�ƾ��C
    //    2^6 = 64 (����), 2^7 = 128 (����)�A�ҥH�ŧi�� 7-bit�C
    reg [6:0] counter_reg;
    
    // 2. �@�� wire ���x�s�u�@�g�����֭� (threshold)�C
    //    duty_in (0~15) * 10 => �̤j�� 150�C
    //    2^7 = 128 (����), 2^8 = 256 (����)�A�ҥH�ŧi�� 8-bit�C
    wire [7:0] threshold;
    
    // ------------------- �q���欰�y�z -------------------

    // 3. �զX�޿�G�p��֭�
    //    �ϥ� assign �Ӵy�z�@�ӯ²զX�޿�q�� (�b�o�̬O�@�ӭ��k��)�C
    //    �����N��O threshold ���� "�û�����" duty_in ���ȭ��H 10�C
    assign threshold = duty_in * 10;
    
    // 4. �`���޿�G�y�z�p�ƾ��M PWM ��X���欰
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // --- ���m�޿� ---
            // �� rst �� 1 �ɡA�j��N�p�ƾ��k�s�A���� PWM ��X�� 0�C
            counter_reg <= 7'd0;
            pwm_out     <= 1'b0;
        end
        else begin
            // --- �p�ƾ��޿� ---
            // �b�C�@�ӮɯߤW�ɽt�A�ˬd�p�ƾ����ȡC
            // �p�G�p�ƾ��w�g�ƨ� 99 (�N��@�� PWM �g������)...
            if (counter_reg == 7'd99) begin
                counter_reg <= 7'd0; // ...�N�N�p�ƾ��k�s�A�ǳƶ}�l�U�@�Ӷg���C
            end
            else begin
                counter_reg <= counter_reg + 1; // ...�_�h�A�N�N�p�ƾ��[ 1�C
            end
            
            // --- PWM ��X����޿� ---
            // �o���޿�P�W�����p�ƾ��޿�O "�æ�" �o�ͪ��C
            // �b�C�@�ӮɯߤW�ɽt�A"�P��" �ˬd�p�ƾ����ȡC
            // �p�G�p�ƾ����Ȥp��ڭ̭p��X���֭�...
            if (counter_reg < threshold) begin
                pwm_out <= 1'b1; // ...��X�N�� 1 (���q��)�C
            end
            else begin
                pwm_out <= 1'b0; // ...�_�h�A��X�N�� 0 (�C�q��)�C
            end
        end
    end

endmodule