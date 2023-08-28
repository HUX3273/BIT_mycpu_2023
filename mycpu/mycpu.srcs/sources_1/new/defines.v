//***************************     ȫ�ֺ궨��   *************************** 

`define RstEnable       1'b1        //��λ�ź���Ч
`define RstDisable      1'b0        //��λ�ź���Ч
`define ZeroWord        32'h0000_0000       //32λ��0
`define WriteEnable     1'b1    //дʹ��
`define WriteDisable    1'b0    // ��ֹд
`define ReadEnable      1'b1    //��ʹ��
`define ReadDisable     1'b0    // ��ֹ��
`define AluOpBus        7:0     //ID�׶ε����aluop_o�Ŀ�ȣ�_o��ʾ�����_i��ʾ���룩
`define AluSelBus       2:0     //ID�׶ε����alusel_o�Ŀ��
`define InstValid       1'b0    //ָ����Ч
`define InstInvalid     1'b1    //ָ����Ч
`define True_v          1'b1    //�߼���
`define False_v         1'b0    //�߼���
`define ChipEnable      1'b1    //оƬʹ��
`define ChipDisable     1'b0    //оƬ��ֹ


//***************************     ָ����صĺ궨��  *************************** 

//special��ָ���ָ���룬26~31bit��
`define EXE_SPECIAL_INST    6'b000_000      //����special��ָ��Ĺ�ָͬ����

//special��ָ��Ĺ����룬0~5bit��
`define EXE_AND     6'b100_100      //AND�Ĺ�����
`define EXE_OR      6'b100_101      //OR�Ĺ�����
`define EXE_XOR     6'b100_110      //XOR�Ĺ�����
`define EXE_NOR     6'b100_111      //NOR�Ĺ�����
`define EXE_SLL     6'b000_000      //SLL�Ĺ�����
`define EXE_SRL     6'b000_010      //SRL�Ĺ�����
`define EXE_SRA     6'b000_011      //SRA�Ĺ�����
`define EXE_SLLV    6'b000_100      //SLLV�Ĺ�����
`define EXE_SRLV    6'b000_110      //SRLV�Ĺ�����
`define EXE_SRAV    6'b000_111      //SRAV�Ĺ�����

`define EXE_ADD     6'b100_000      //ADD�Ĺ����루���������������ʱ����������
`define EXE_ADDU    6'b100_001      //ADDU�Ĺ����루�޷��������㲻��������
`define EXE_SUB     6'b100_010      //SUB�Ĺ�����
`define EXE_SUBU    6'b100_011      //SUBU�Ĺ�����
`define EXE_SLT     6'b101_010      //SLT�Ĺ�����
`define EXE_SLTU    6'b101_011      //SLTU�Ĺ�����

//��special��ָ���ָ���룬26~31bit��
`define EXE_ANDI    6'b001_100      //ANDI��ָ����
`define EXE_ORI     6'b001_101      //ori��ָ����
`define EXE_XORI    6'b001_110      //xori��ָ����
`define EXE_LUI     6'b001_111      //lui��ָ����
`define EXE_NOP     6'b000_000      //nop


//Aluִ�е���������op
`define EXE_AND_OP      8'b0010_0100
`define EXE_OR_OP       8'b0010_0101
`define EXE_XOR_OP       8'b0010_0110 
`define EXE_NOR_OP       8'b0010_0111
`define EXE_SLL_OP       8'b0000_0000
`define EXE_SRL_OP       8'b0000_0010
`define EXE_SRA_OP       8'b0000_0011

`define EXE_ADD_OP      8'b0010_0000
`define EXE_ADDU_OP     8'b0010_0001
`define EXE_SUB_OP      8'b0010_0010
`define EXE_SUBU_OP      8'b0010_0011
`define EXE_SLT_OP      8'b0010_1010
`define EXE_SLTU_OP     8'b0010_1011

`define EXE_NOP_OP      8'b0000_0000


//Aluִ�еĽ������sel
`define EXE_RES_LOGIC       3'b001//�߼�
`define EXE_RES_SHIFT       3'b010//��λ
`define EXE_RES_ARITHMETIC  3'b011//����
`define EXE_RES_NOP         3'b000


//***************************     ָ��Ĵ���ROM��صĺ궨��   *************************** 

`define InstAddrBus         31:0        // ROM�ĵ�ַ���߿��
`define InstBus             31:0        //ROM���������߿��
`define InstMemNum          4096        //ROM��ʵ�ʴ�СΪ4096B
`define InstMemNumLog2      10          //ROMʵ�ʵĵ�ַ���,2^10=1K,1K*4B=4KB


//***************************     ͨ�üĴ���Regfile��صĺ궨��   *************************** 

`define RegAddrBus      4:0     //Regfileģ��ĵ�ַ�߿�ȣ���Ϊֻ��32��ͨ�üĴ�������ֻ��Ҫ5λ
`define RegBus          31:0    //Regfileģ��������߿��
`define RegWidth        32      //ͨ�üĴ����Ŀ��
`define DoubleRegWidth  64      //����ͨ�üĴ����Ŀ��
`define DoubleRegBus    63:0    //����ͨ�üĴ����������߿��
`define RegNum          32      //ͨ�üĴ���������
`define RegNumLog2      5       //Ѱַͨ�üĴ���ʹ�õĵ�ַλ������Ϊֻ��32��ͨ�üĴ�������ֻ��Ҫ5λ
`define NOPRegAddr      5'b00000
