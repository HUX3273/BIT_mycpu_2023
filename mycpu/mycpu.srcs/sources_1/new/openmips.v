`timescale 1ns / 1ps

module openmips(
    input   wire  clk,
    input   wire  rst,
    
    input   wire[`RegBus]   rom_data_i, //从指令rom中取出的指令  
    output  wire[`RegBus]   rom_addr_o, //输出到指令rom的地址
    output  wire            rom_ce_o    //指令rom的芯片使能信号
    

    );
    
    
// ************************************ 定义模块间的连线 ************************************
    //if_id -> id
    wire[`InstAddrBus]  pc;         //output to id
    wire[`InstAddrBus]  id_pc_i;    //input from if
    wire[`InstBus]      id_inst_i;  //input from if
    
    //id -> id_ex
    wire[`AluOpBus]     id_aluop_o;
    wire[`AluSelBus]    id_alusel_o;
    wire[`RegBus]       id_reg1_o;
    wire[`RegBus]       id_reg2_o;
    wire                id_wreg_o;
    wire[`RegAddrBus]   id_wDestRegAddr_o;
    wire                id_in_delayslot_o;
    wire                id_next_inst_in_delayslot_o;
    
    //id_ex -> ex
    wire[`AluOpBus]     ex_aluop_i;
    wire[`AluSelBus]    ex_alusel_i;
    wire[`RegBus]       ex_reg1_i;
    wire[`RegBus]       ex_reg2_i;
    wire                ex_wreg_i;
    wire[`RegAddrBus]   ex_wDestRegAddr_i;
    wire                ex_in_delayslot_o;      
    
    
    //ex -> ex_mem
    //ex -> id（数据冒险）
    wire                ex_wreg_o;
    wire[`RegAddrBus]   ex_wDestRegAddr_o;
    wire[`RegBus]       ex_wdata_o;
    
    //ex_mem -> mem
    wire                mem_wreg_i;
    wire[`RegAddrBus]   mem_wDestRegAddr_i;
    wire[`RegBus]       mem_wdata_i;
    
    //mem -> mem_wb
    //mem -> id（数据冒险）
    wire                mem_wreg_o;
    wire[`RegAddrBus]   mem_wDestRegAddr_o;
    wire[`RegBus]       mem_wdata_o;
    
    //mem_wb -> wb（regfile）
    wire                wb_wreg_i;
    wire[`RegAddrBus]   wb_wDestRegAddr_i;
    wire[`RegBus]       wb_wdata_i;
    
    //id -> regfile
    wire                reg1_read;  
    wire                reg2_read;  
    wire[`RegBus]       reg1_data;  
    wire[`RegBus]       reg2_data;  
    wire[`RegAddrBus]   reg1_addr;  
    wire[`RegAddrBus]   reg2_addr;  
    
    //id -> pc
    wire                branch_flag;
    wire[`RegBus]       branch_target_addr;
         
    //id_ex -> id
    wire                in_delayslot;
    
    
    
    
// ************************************ 实例化各个模块 ************************************  
    //pc_reg实例化（对应if段）
    pc_reg pc_reg0(
        .clk(clk),  .rst(rst),  
        //输出到指令rom的信息（pc还会传给if_id段）
        .pc(pc),    .ce(rom_ce_o),
        .branch_flag_i(branch_flag),    .branch_target_addr_i(branch_target_addr)
    );
    
    assign rom_addr_o = pc; //指令rom的指令地址即pc，指令rom根据pc取出指令后，在下个时钟周期通过rom_data_i送回本模块
    
    //if_id实例化
    if_id if_id0(
        .clk(clk),  .rst(rst),  
        
        //从if段传来的信息
        .if_pc(pc), .if_inst(rom_data_i),   
        
        //输出到id段的信息
        .id_pc(id_pc_i),   .id_inst(id_inst_i)
    );
    
    //id实例化
    id id0(
        .rst(rst),  .pc_i(id_pc_i), .inst_i(id_inst_i),
        
        .reg1_data_i(reg1_data),    .reg2_data_i(reg2_data),    //input from regfile，从读地址读出的数据
        .reg1_read_o(reg1_read),    .reg2_read_o(reg2_read),    //output to regfile，读使能信号
        .reg1_addr_o(reg1_addr),    .reg2_addr_o(reg2_addr),    //output to regfile，读地址
        
        //output to id_ex
        .aluop_o(id_aluop_o),   .alusel_o(id_alusel_o),
        .reg1_o(id_reg1_o),     .reg2_o(id_reg2_o),
        .wDestRegAddr_o(id_wDestRegAddr_o), .wreg_o(id_wreg_o),
        
        //连接数据旁路，解决数据冒险
        .ex_wreg_i(ex_wreg_o),   .ex_wDestRegAddr_i(ex_wDestRegAddr_o),   .ex_wdata_i(ex_wdata_o),
        .mem_wreg_i(mem_wreg_o),   .mem_wDestRegAddr_i(mem_wDestRegAddr_o),   .mem_wdata_i(mem_wdata_o),
        
        //J
        .branch_flag_o(branch_flag),    .branch_target_addr_o(branch_target_addr),
        .in_delayslot_o(id_in_delayslot_o), .next_inst_in_delayslot_o(id_next_inst_in_delayslot_o),
        .in_delayslot_i(in_delayslot)
    );
    
    //regfile实例化（包括了写回段）
    regfile regfile0(
        .clk(clk),  .rst(rst),
        .we(wb_wreg_i), .wRegAddr(wb_wDestRegAddr_i),   .wdata(wb_wdata_i), //写端口1接收写回阶段数据wdata
        .re1(reg1_read),    .rRegAddr1(reg1_addr),   .rdata1(reg1_data),    //从读端口1按照地址取出数据rdata1并输出
        .re2(reg2_read),    .rRegAddr2(reg2_addr),   .rdata2(reg2_data)     //从读端口2按照地址取出数据rdata2并输出
    );
    
    //id_ex实例化
    id_ex id_ex0(
        .clk(clk),  .rst(rst),
        
        //从id段传来的信息
        .id_aluop(id_aluop_o),  .id_alusel(id_alusel_o),
        .id_reg1(id_reg1_o),    .id_reg2(id_reg2_o),
        .id_wDestRegAddr(id_wDestRegAddr_o),    .id_wreg(id_wreg_o),
        
        //传递到ex段的信息
        .ex_aluop(ex_aluop_i),  .ex_alusel(ex_alusel_i), 
        .ex_reg1(ex_reg1_i),    .ex_reg2(ex_reg2_i), 
        .ex_wDestRegAddr(ex_wDestRegAddr_i),    .ex_wreg(ex_wreg_i),
        
        //J
        .id_in_delayslot(id_in_delayslot_o),    .next_inst_in_delayslot_i(id_next_inst_in_delayslot_o),
        .in_delayslot_o(in_delayslot),      .ex_in_delayslot(ex_in_delayslot_o)
        
    );
    
    //ex实例化
    ex ex0(
        .rst(rst),
        
        //从id_ex传来的信息
        .aluop_i(ex_aluop_i),   .alusel_i(ex_alusel_i),
        .src1_i(ex_reg1_i),     .src2_i(ex_reg2_i),
        .wreg_i(ex_wreg_i),     .wDestRegAddr_i(ex_wDestRegAddr_i),
        
        //输出到ex_mem的信息
        .wreg_o(ex_wreg_o),     .wDestRegAddr_o(ex_wDestRegAddr_o),
        .wdata_o(ex_wdata_o),
        
        //J
        .in_delayslot_i(ex_in_delayslot_o)
    );
    
    //ex_mem实例化
    ex_mem ex_mem0(
        .clk(clk),  .rst(rst),
        
        //从ex段传来的信息
        .ex_wreg(ex_wreg_o),     .ex_wDestRegAddr(ex_wDestRegAddr_o),
        .ex_wdata(ex_wdata_o),
        
        //输出到mem段的信息
        .mem_wreg(mem_wreg_i),     .mem_wDestRegAddr(mem_wDestRegAddr_i),
        .mem_wdata(mem_wdata_i)
    );
    
    //mem实例化
    mem mem0(
        .rst(rst),
        
        //从ex_mem段传来的信息
        .wreg_i(mem_wreg_i),     .wDestRegAddr_i(mem_wDestRegAddr_i),
        .wdata_i(mem_wdata_i),
        
        //输出到mem_wb的信息
        .wreg_o(mem_wreg_o),     .wDestRegAddr_o(mem_wDestRegAddr_o),
        .wdata_o(mem_wdata_o)
    );
    
    //mem_wb实例化
    mem_wb mem_wb0(
        .clk(clk),  .rst(rst),
        
        //从mem段传来的信息
        .mem_wreg(mem_wreg_o),     .mem_wDestRegAddr(mem_wDestRegAddr_o),
        .mem_wdata(mem_wdata_o),
        
        //输出到wb段的信息
        .wb_wreg(wb_wreg_i),     .wb_wDestRegAddr(wb_wDestRegAddr_i),
        .wb_wdata(wb_wdata_i)
    );
    
endmodule
