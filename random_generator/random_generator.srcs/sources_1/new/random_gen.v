// �ҲզW�١Grandom_gen
// �\��G�ϥ� 5-bit LFSR (��� CRC5) ���ͤ@�� 2-bit �����H����
module random_gen(
    input clk,
    input rst,
    input enable, // �� enable �� 1 �ɡA�~���ͷs���H����
    
    output [1:0] random_out // 2-bit ���H���ƿ�X (0~3)
    );

    // 1. �ŧi LFSR �֤ߪ� 5-bit �Ȧs��   
    reg [4:0] lfsr_reg;
    
    // 2. �ŧi�@�� wire ���x�s�^�X�줸 (feedback bit) ���p�⵲�G
    wire feedback_bit;
    
    // 3. �y�z�^�X�줸�� "�զX�޿�"
    //    �ϥ� assign �Ӵy�z�@�ӲզX�޿�q�� (�@�� XOR �h)
    //    �^�X�u���Ӧ۲� 5 �줸(lfsr_reg[4]) �M�� 2 �줸(lfsr_reg[1])
    //    ^ �O Verilog ���� XOR �B��l
    assign feedback_bit = lfsr_reg[4] ^ lfsr_reg[1];
    
    // 4. �y�z LFSR �Ȧs���� "�`���޿�"
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // �b���m�ɡA�����@�� "�D�s" ����l�� (�ؤl)
            lfsr_reg <= 5'b11111;
        end
        else begin
            // �u���b enable �� 1 ���ɭԡA�~�i�沾���s
            if (enable) begin
                // {a, b} �O�걵�B��l (Concatenation)
                // {lfsr_reg[3:0], feedback_bit} ���N��O�G
                // �� lfsr_reg �� bit 3 �� 0 �@���s�� bit 4 �� 1�A
                // �A�� feedback_bit �@���s�� bit 0�C
                // �o�N�����F�@���u���� + ��J�s�줸�v���ާ@�C
                lfsr_reg <= {lfsr_reg[3:0], feedback_bit};
            end
            // �p�G enable ���� 1�Alfsr_reg ���|�Q��ȡA�ҥH�|�O����Ȥ���
        end
    end
    
    // 5. �y�z��X�޿�
    //    �����q 5-bit �� LFSR �����X�C 2-bit �@���ڭ̪��H���ƿ�X
    assign random_out = lfsr_reg[1:0];

endmodule