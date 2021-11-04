library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.toplevel_globals.all;
use work.toplevel_gcu_opcodes.all;

entity toplevel_decoder is

  port (
    instructionword : in std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
    pc_load : out std_logic;
    ra_load : out std_logic;
    pc_opcode : out std_logic_vector(0 downto 0);
    lock : in std_logic;
    lock_r : out std_logic;
    clk : in std_logic;
    rstx : in std_logic;
    simm_B1 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1 : out std_logic_vector(0 downto 0);
    simm_B1_1 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_1 : out std_logic_vector(0 downto 0);
    simm_B1_2 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_2 : out std_logic_vector(0 downto 0);
    simm_B1_3 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_3 : out std_logic_vector(0 downto 0);
    simm_B1_4 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_4 : out std_logic_vector(0 downto 0);
    simm_B1_5 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_5 : out std_logic_vector(0 downto 0);
    simm_B1_6 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_6 : out std_logic_vector(0 downto 0);
    simm_B1_7 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_7 : out std_logic_vector(0 downto 0);
    socket_lsu_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_lsu_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_lsu_i2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_bool_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_bool_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_gcu_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_gcu_i2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_gcu_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_ALU_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_ALU_i2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_ALU_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_ADDSH_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_ADDSH_i2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_ADDSH_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_MUL_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_MUL_i2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_MUL_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_RF_0_1_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_RF_0_1_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_0_2_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_RF_0_2_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_2_1_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_RF_2_1_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_2_2_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_RF_2_2_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_INPUT_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_INPUT_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_INPUT_o2_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_RF_5_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_RF_5_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_ADDSH_1_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_ADDSH_1_i2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_ADDSH_1_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    socket_MUL_1_i1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_MUL_1_i2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_MUL_1_o1_bus_cntrl : out std_logic_vector(7 downto 0);
    fu_LSU_in1t_load : out std_logic;
    fu_LSU_in2_load : out std_logic;
    fu_LSU_opc : out std_logic_vector(2 downto 0);
    fu_ALU_in1t_load : out std_logic;
    fu_ALU_in2_load : out std_logic;
    fu_ALU_opc : out std_logic_vector(3 downto 0);
    fu_ADDSH_in1t_load : out std_logic;
    fu_ADDSH_in2_load : out std_logic;
    fu_ADDSH_opc : out std_logic_vector(2 downto 0);
    fu_MUL_in1t_load : out std_logic;
    fu_MUL_in2_load : out std_logic;
    fu_OUTPUT_in1t_load : out std_logic;
    fu_OUTPUT_opc : out std_logic_vector(0 downto 0);
    fu_INPUT_in1t_load : out std_logic;
    fu_INPUT_opc : out std_logic_vector(0 downto 0);
    fu_ADDSH_1_in1t_load : out std_logic;
    fu_ADDSH_1_in2_load : out std_logic;
    fu_ADDSH_1_opc : out std_logic_vector(2 downto 0);
    fu_MUL_1_in1t_load : out std_logic;
    fu_MUL_1_in2_load : out std_logic;
    rf_RF_0_wr_load : out std_logic;
    rf_RF_0_wr_opc : out std_logic_vector(2 downto 0);
    rf_RF_0_rd_load : out std_logic;
    rf_RF_0_rd_opc : out std_logic_vector(2 downto 0);
    rf_BOOL_wr_load : out std_logic;
    rf_BOOL_wr_opc : out std_logic_vector(0 downto 0);
    rf_BOOL_rd_load : out std_logic;
    rf_BOOL_rd_opc : out std_logic_vector(0 downto 0);
    rf_RF_1_wr_load : out std_logic;
    rf_RF_1_wr_opc : out std_logic_vector(2 downto 0);
    rf_RF_1_rd_load : out std_logic;
    rf_RF_1_rd_opc : out std_logic_vector(2 downto 0);
    rf_RF_2_wr_load : out std_logic;
    rf_RF_2_wr_opc : out std_logic_vector(2 downto 0);
    rf_RF_2_rd_load : out std_logic;
    rf_RF_2_rd_opc : out std_logic_vector(2 downto 0);
    rf_RF_3_wr_load : out std_logic;
    rf_RF_3_wr_opc : out std_logic_vector(2 downto 0);
    rf_RF_3_rd_load : out std_logic;
    rf_RF_3_rd_opc : out std_logic_vector(2 downto 0);
    rf_RF_4_wr_load : out std_logic;
    rf_RF_4_wr_opc : out std_logic_vector(2 downto 0);
    rf_RF_4_rd_load : out std_logic;
    rf_RF_4_rd_opc : out std_logic_vector(2 downto 0);
    rf_RF_5_wr_load : out std_logic;
    rf_RF_5_wr_opc : out std_logic_vector(2 downto 0);
    rf_RF_5_rd_load : out std_logic;
    rf_RF_5_rd_opc : out std_logic_vector(2 downto 0);
    rf_guard_BOOL_0 : in std_logic;
    rf_guard_BOOL_1 : in std_logic;
    glock : out std_logic);

end toplevel_decoder;

architecture rtl_andor of toplevel_decoder is

  -- signals for source, destination and guard fields
  signal src_B1 : std_logic_vector(32 downto 0);
  signal dst_B1 : std_logic_vector(6 downto 0);
  signal grd_B1 : std_logic_vector(2 downto 0);
  signal src_B1_1 : std_logic_vector(32 downto 0);
  signal dst_B1_1 : std_logic_vector(6 downto 0);
  signal grd_B1_1 : std_logic_vector(2 downto 0);
  signal src_B1_2 : std_logic_vector(32 downto 0);
  signal dst_B1_2 : std_logic_vector(6 downto 0);
  signal grd_B1_2 : std_logic_vector(2 downto 0);
  signal src_B1_3 : std_logic_vector(32 downto 0);
  signal dst_B1_3 : std_logic_vector(6 downto 0);
  signal grd_B1_3 : std_logic_vector(2 downto 0);
  signal src_B1_4 : std_logic_vector(32 downto 0);
  signal dst_B1_4 : std_logic_vector(6 downto 0);
  signal src_B1_5 : std_logic_vector(32 downto 0);
  signal dst_B1_5 : std_logic_vector(6 downto 0);
  signal src_B1_6 : std_logic_vector(32 downto 0);
  signal dst_B1_6 : std_logic_vector(6 downto 0);
  signal src_B1_7 : std_logic_vector(32 downto 0);
  signal dst_B1_7 : std_logic_vector(6 downto 0);

  -- signals for dedicated immediate slots


  -- squash signals
  signal squash_B1 : std_logic;
  signal squash_B1_1 : std_logic;
  signal squash_B1_2 : std_logic;
  signal squash_B1_3 : std_logic;
  signal squash_B1_4 : std_logic;
  signal squash_B1_5 : std_logic;
  signal squash_B1_6 : std_logic;
  signal squash_B1_7 : std_logic;

  -- socket control signals
  signal socket_lsu_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_lsu_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_lsu_i2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_bool_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_bool_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_gcu_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_gcu_i2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_gcu_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_ALU_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_ALU_i2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_ALU_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_ADDSH_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_ADDSH_i2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_ADDSH_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_MUL_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_MUL_i2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_MUL_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_RF_0_1_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_RF_0_1_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_0_2_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_RF_0_2_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_2_1_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_RF_2_1_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_2_2_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_RF_2_2_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_INPUT_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_INPUT_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_INPUT_o2_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_RF_5_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_RF_5_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_ADDSH_1_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_ADDSH_1_i2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_ADDSH_1_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal socket_MUL_1_i1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_MUL_1_i2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_MUL_1_o1_bus_cntrl_reg : std_logic_vector(7 downto 0);
  signal simm_B1_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_reg : std_logic_vector(0 downto 0);
  signal simm_B1_1_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_1_reg : std_logic_vector(0 downto 0);
  signal simm_B1_2_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_2_reg : std_logic_vector(0 downto 0);
  signal simm_B1_3_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_3_reg : std_logic_vector(0 downto 0);
  signal simm_B1_4_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_4_reg : std_logic_vector(0 downto 0);
  signal simm_B1_5_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_5_reg : std_logic_vector(0 downto 0);
  signal simm_B1_6_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_6_reg : std_logic_vector(0 downto 0);
  signal simm_B1_7_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_7_reg : std_logic_vector(0 downto 0);

  -- FU control signals
  signal fu_LSU_in1t_load_reg : std_logic;
  signal fu_LSU_in2_load_reg : std_logic;
  signal fu_LSU_opc_reg : std_logic_vector(2 downto 0);
  signal fu_ALU_in1t_load_reg : std_logic;
  signal fu_ALU_in2_load_reg : std_logic;
  signal fu_ALU_opc_reg : std_logic_vector(3 downto 0);
  signal fu_ADDSH_in1t_load_reg : std_logic;
  signal fu_ADDSH_in2_load_reg : std_logic;
  signal fu_ADDSH_opc_reg : std_logic_vector(2 downto 0);
  signal fu_MUL_in1t_load_reg : std_logic;
  signal fu_MUL_in2_load_reg : std_logic;
  signal fu_OUTPUT_in1t_load_reg : std_logic;
  signal fu_OUTPUT_opc_reg : std_logic_vector(0 downto 0);
  signal fu_INPUT_in1t_load_reg : std_logic;
  signal fu_INPUT_opc_reg : std_logic_vector(0 downto 0);
  signal fu_ADDSH_1_in1t_load_reg : std_logic;
  signal fu_ADDSH_1_in2_load_reg : std_logic;
  signal fu_ADDSH_1_opc_reg : std_logic_vector(2 downto 0);
  signal fu_MUL_1_in1t_load_reg : std_logic;
  signal fu_MUL_1_in2_load_reg : std_logic;
  signal fu_gcu_pc_load_reg : std_logic;
  signal fu_gcu_ra_load_reg : std_logic;
  signal fu_gcu_opc_reg : std_logic_vector(0 downto 0);

  -- RF control signals
  signal rf_RF_0_wr_load_reg : std_logic;
  signal rf_RF_0_wr_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_0_rd_load_reg : std_logic;
  signal rf_RF_0_rd_opc_reg : std_logic_vector(2 downto 0);
  signal rf_BOOL_wr_load_reg : std_logic;
  signal rf_BOOL_wr_opc_reg : std_logic_vector(0 downto 0);
  signal rf_BOOL_rd_load_reg : std_logic;
  signal rf_BOOL_rd_opc_reg : std_logic_vector(0 downto 0);
  signal rf_RF_1_wr_load_reg : std_logic;
  signal rf_RF_1_wr_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_1_rd_load_reg : std_logic;
  signal rf_RF_1_rd_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_2_wr_load_reg : std_logic;
  signal rf_RF_2_wr_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_2_rd_load_reg : std_logic;
  signal rf_RF_2_rd_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_3_wr_load_reg : std_logic;
  signal rf_RF_3_wr_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_3_rd_load_reg : std_logic;
  signal rf_RF_3_rd_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_4_wr_load_reg : std_logic;
  signal rf_RF_4_wr_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_4_rd_load_reg : std_logic;
  signal rf_RF_4_rd_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_5_wr_load_reg : std_logic;
  signal rf_RF_5_wr_opc_reg : std_logic_vector(2 downto 0);
  signal rf_RF_5_rd_load_reg : std_logic;
  signal rf_RF_5_rd_opc_reg : std_logic_vector(2 downto 0);

begin

  -- dismembering of instruction
  process (instructionword)
  begin --process
    src_B1 <= instructionword(39 downto 7);
    dst_B1 <= instructionword(6 downto 0);
    grd_B1 <= instructionword(42 downto 40);
    src_B1_1 <= instructionword(82 downto 50);
    dst_B1_1 <= instructionword(49 downto 43);
    grd_B1_1 <= instructionword(85 downto 83);
    src_B1_2 <= instructionword(125 downto 93);
    dst_B1_2 <= instructionword(92 downto 86);
    grd_B1_2 <= instructionword(128 downto 126);
    src_B1_3 <= instructionword(168 downto 136);
    dst_B1_3 <= instructionword(135 downto 129);
    grd_B1_3 <= instructionword(171 downto 169);
    src_B1_4 <= instructionword(211 downto 179);
    dst_B1_4 <= instructionword(178 downto 172);
    src_B1_5 <= instructionword(251 downto 219);
    dst_B1_5 <= instructionword(218 downto 212);
    src_B1_6 <= instructionword(291 downto 259);
    dst_B1_6 <= instructionword(258 downto 252);
    src_B1_7 <= instructionword(331 downto 299);
    dst_B1_7 <= instructionword(298 downto 292);

  end process;

  -- map control registers to outputs
  fu_LSU_in1t_load <= fu_LSU_in1t_load_reg;
  fu_LSU_in2_load <= fu_LSU_in2_load_reg;
  fu_LSU_opc <= fu_LSU_opc_reg;

  fu_ALU_in1t_load <= fu_ALU_in1t_load_reg;
  fu_ALU_in2_load <= fu_ALU_in2_load_reg;
  fu_ALU_opc <= fu_ALU_opc_reg;

  fu_ADDSH_in1t_load <= fu_ADDSH_in1t_load_reg;
  fu_ADDSH_in2_load <= fu_ADDSH_in2_load_reg;
  fu_ADDSH_opc <= fu_ADDSH_opc_reg;

  fu_MUL_in1t_load <= fu_MUL_in1t_load_reg;
  fu_MUL_in2_load <= fu_MUL_in2_load_reg;

  fu_OUTPUT_in1t_load <= fu_OUTPUT_in1t_load_reg;
  fu_OUTPUT_opc <= fu_OUTPUT_opc_reg;

  fu_INPUT_in1t_load <= fu_INPUT_in1t_load_reg;
  fu_INPUT_opc <= fu_INPUT_opc_reg;

  fu_ADDSH_1_in1t_load <= fu_ADDSH_1_in1t_load_reg;
  fu_ADDSH_1_in2_load <= fu_ADDSH_1_in2_load_reg;
  fu_ADDSH_1_opc <= fu_ADDSH_1_opc_reg;

  fu_MUL_1_in1t_load <= fu_MUL_1_in1t_load_reg;
  fu_MUL_1_in2_load <= fu_MUL_1_in2_load_reg;

  ra_load <= fu_gcu_ra_load_reg;
  pc_load <= fu_gcu_pc_load_reg;
  pc_opcode <= fu_gcu_opc_reg;
  rf_RF_0_wr_load <= rf_RF_0_wr_load_reg;
  rf_RF_0_wr_opc <= rf_RF_0_wr_opc_reg;
  rf_RF_0_rd_load <= rf_RF_0_rd_load_reg;
  rf_RF_0_rd_opc <= rf_RF_0_rd_opc_reg;
  rf_BOOL_wr_load <= rf_BOOL_wr_load_reg;
  rf_BOOL_wr_opc <= rf_BOOL_wr_opc_reg;
  rf_BOOL_rd_load <= rf_BOOL_rd_load_reg;
  rf_BOOL_rd_opc <= rf_BOOL_rd_opc_reg;
  rf_RF_1_wr_load <= rf_RF_1_wr_load_reg;
  rf_RF_1_wr_opc <= rf_RF_1_wr_opc_reg;
  rf_RF_1_rd_load <= rf_RF_1_rd_load_reg;
  rf_RF_1_rd_opc <= rf_RF_1_rd_opc_reg;
  rf_RF_2_wr_load <= rf_RF_2_wr_load_reg;
  rf_RF_2_wr_opc <= rf_RF_2_wr_opc_reg;
  rf_RF_2_rd_load <= rf_RF_2_rd_load_reg;
  rf_RF_2_rd_opc <= rf_RF_2_rd_opc_reg;
  rf_RF_3_wr_load <= rf_RF_3_wr_load_reg;
  rf_RF_3_wr_opc <= rf_RF_3_wr_opc_reg;
  rf_RF_3_rd_load <= rf_RF_3_rd_load_reg;
  rf_RF_3_rd_opc <= rf_RF_3_rd_opc_reg;
  rf_RF_4_wr_load <= rf_RF_4_wr_load_reg;
  rf_RF_4_wr_opc <= rf_RF_4_wr_opc_reg;
  rf_RF_4_rd_load <= rf_RF_4_rd_load_reg;
  rf_RF_4_rd_opc <= rf_RF_4_rd_opc_reg;
  rf_RF_5_wr_load <= rf_RF_5_wr_load_reg;
  rf_RF_5_wr_opc <= rf_RF_5_wr_opc_reg;
  rf_RF_5_rd_load <= rf_RF_5_rd_load_reg;
  rf_RF_5_rd_opc <= rf_RF_5_rd_opc_reg;
  socket_lsu_i1_bus_cntrl <= socket_lsu_i1_bus_cntrl_reg;
  socket_lsu_o1_bus_cntrl <= socket_lsu_o1_bus_cntrl_reg;
  socket_lsu_i2_bus_cntrl <= socket_lsu_i2_bus_cntrl_reg;
  socket_RF_i1_bus_cntrl <= socket_RF_i1_bus_cntrl_reg;
  socket_RF_o1_bus_cntrl <= socket_RF_o1_bus_cntrl_reg;
  socket_bool_i1_bus_cntrl <= socket_bool_i1_bus_cntrl_reg;
  socket_bool_o1_bus_cntrl <= socket_bool_o1_bus_cntrl_reg;
  socket_gcu_i1_bus_cntrl <= socket_gcu_i1_bus_cntrl_reg;
  socket_gcu_i2_bus_cntrl <= socket_gcu_i2_bus_cntrl_reg;
  socket_gcu_o1_bus_cntrl <= socket_gcu_o1_bus_cntrl_reg;
  socket_ALU_i1_bus_cntrl <= socket_ALU_i1_bus_cntrl_reg;
  socket_ALU_i2_bus_cntrl <= socket_ALU_i2_bus_cntrl_reg;
  socket_ALU_o1_bus_cntrl <= socket_ALU_o1_bus_cntrl_reg;
  socket_ADDSH_i1_bus_cntrl <= socket_ADDSH_i1_bus_cntrl_reg;
  socket_ADDSH_i2_bus_cntrl <= socket_ADDSH_i2_bus_cntrl_reg;
  socket_ADDSH_o1_bus_cntrl <= socket_ADDSH_o1_bus_cntrl_reg;
  socket_MUL_i1_bus_cntrl <= socket_MUL_i1_bus_cntrl_reg;
  socket_MUL_i2_bus_cntrl <= socket_MUL_i2_bus_cntrl_reg;
  socket_MUL_o1_bus_cntrl <= socket_MUL_o1_bus_cntrl_reg;
  socket_RF_0_1_o1_bus_cntrl <= socket_RF_0_1_o1_bus_cntrl_reg;
  socket_RF_0_1_i1_bus_cntrl <= socket_RF_0_1_i1_bus_cntrl_reg;
  socket_RF_0_2_o1_bus_cntrl <= socket_RF_0_2_o1_bus_cntrl_reg;
  socket_RF_0_2_i1_bus_cntrl <= socket_RF_0_2_i1_bus_cntrl_reg;
  socket_RF_2_1_o1_bus_cntrl <= socket_RF_2_1_o1_bus_cntrl_reg;
  socket_RF_2_1_i1_bus_cntrl <= socket_RF_2_1_i1_bus_cntrl_reg;
  socket_RF_2_2_o1_bus_cntrl <= socket_RF_2_2_o1_bus_cntrl_reg;
  socket_RF_2_2_i1_bus_cntrl <= socket_RF_2_2_i1_bus_cntrl_reg;
  socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl <= socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg;
  socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl <= socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg;
  socket_INPUT_i1_bus_cntrl <= socket_INPUT_i1_bus_cntrl_reg;
  socket_INPUT_o1_bus_cntrl <= socket_INPUT_o1_bus_cntrl_reg;
  socket_INPUT_o2_bus_cntrl <= socket_INPUT_o2_bus_cntrl_reg;
  socket_RF_5_o1_bus_cntrl <= socket_RF_5_o1_bus_cntrl_reg;
  socket_RF_5_i1_bus_cntrl <= socket_RF_5_i1_bus_cntrl_reg;
  socket_ADDSH_1_i1_bus_cntrl <= socket_ADDSH_1_i1_bus_cntrl_reg;
  socket_ADDSH_1_i2_bus_cntrl <= socket_ADDSH_1_i2_bus_cntrl_reg;
  socket_ADDSH_1_o1_bus_cntrl <= socket_ADDSH_1_o1_bus_cntrl_reg;
  socket_MUL_1_i1_bus_cntrl <= socket_MUL_1_i1_bus_cntrl_reg;
  socket_MUL_1_i2_bus_cntrl <= socket_MUL_1_i2_bus_cntrl_reg;
  socket_MUL_1_o1_bus_cntrl <= socket_MUL_1_o1_bus_cntrl_reg;
  simm_cntrl_B1 <= simm_cntrl_B1_reg;
  simm_B1 <= simm_B1_reg;
  simm_cntrl_B1_1 <= simm_cntrl_B1_1_reg;
  simm_B1_1 <= simm_B1_1_reg;
  simm_cntrl_B1_2 <= simm_cntrl_B1_2_reg;
  simm_B1_2 <= simm_B1_2_reg;
  simm_cntrl_B1_3 <= simm_cntrl_B1_3_reg;
  simm_B1_3 <= simm_B1_3_reg;
  simm_cntrl_B1_4 <= simm_cntrl_B1_4_reg;
  simm_B1_4 <= simm_B1_4_reg;
  simm_cntrl_B1_5 <= simm_cntrl_B1_5_reg;
  simm_B1_5 <= simm_B1_5_reg;
  simm_cntrl_B1_6 <= simm_cntrl_B1_6_reg;
  simm_B1_6 <= simm_B1_6_reg;
  simm_cntrl_B1_7 <= simm_cntrl_B1_7_reg;
  simm_B1_7 <= simm_B1_7_reg;

  -- generate signal squash_B1
  process (rf_guard_BOOL_0, rf_guard_BOOL_1, grd_B1)
    variable sel : integer;
  begin --process
    sel := conv_integer(unsigned(grd_B1));
    case sel is
      when 1 =>
        squash_B1 <= not rf_guard_BOOL_0;
      when 2 =>
        squash_B1 <= rf_guard_BOOL_0;
      when 3 =>
        squash_B1 <= not rf_guard_BOOL_1;
      when 4 =>
        squash_B1 <= rf_guard_BOOL_1;
      when others =>
        squash_B1 <= '0';
    end case;
  end process;

  -- generate signal squash_B1_1
  process (rf_guard_BOOL_0, rf_guard_BOOL_1, grd_B1_1)
    variable sel : integer;
  begin --process
    sel := conv_integer(unsigned(grd_B1_1));
    case sel is
      when 1 =>
        squash_B1_1 <= not rf_guard_BOOL_0;
      when 2 =>
        squash_B1_1 <= rf_guard_BOOL_0;
      when 3 =>
        squash_B1_1 <= not rf_guard_BOOL_1;
      when 4 =>
        squash_B1_1 <= rf_guard_BOOL_1;
      when others =>
        squash_B1_1 <= '0';
    end case;
  end process;

  -- generate signal squash_B1_2
  process (rf_guard_BOOL_0, rf_guard_BOOL_1, grd_B1_2)
    variable sel : integer;
  begin --process
    sel := conv_integer(unsigned(grd_B1_2));
    case sel is
      when 1 =>
        squash_B1_2 <= not rf_guard_BOOL_0;
      when 2 =>
        squash_B1_2 <= rf_guard_BOOL_0;
      when 3 =>
        squash_B1_2 <= not rf_guard_BOOL_1;
      when 4 =>
        squash_B1_2 <= rf_guard_BOOL_1;
      when others =>
        squash_B1_2 <= '0';
    end case;
  end process;

  -- generate signal squash_B1_3
  process (rf_guard_BOOL_0, rf_guard_BOOL_1, grd_B1_3)
    variable sel : integer;
  begin --process
    sel := conv_integer(unsigned(grd_B1_3));
    case sel is
      when 1 =>
        squash_B1_3 <= not rf_guard_BOOL_0;
      when 2 =>
        squash_B1_3 <= rf_guard_BOOL_0;
      when 3 =>
        squash_B1_3 <= not rf_guard_BOOL_1;
      when 4 =>
        squash_B1_3 <= rf_guard_BOOL_1;
      when others =>
        squash_B1_3 <= '0';
    end case;
  end process;

  -- generate signal squash_B1_4
  squash_B1_4 <= '0';
  -- generate signal squash_B1_5
  squash_B1_5 <= '0';
  -- generate signal squash_B1_6
  squash_B1_6 <= '0';
  -- generate signal squash_B1_7
  squash_B1_7 <= '0';


  -- main decoding process
  process (clk, rstx)
  begin
    if (rstx = '0') then
      socket_lsu_i1_bus_cntrl_reg <= (others => '0');
      socket_lsu_o1_bus_cntrl_reg <= (others => '0');
      socket_lsu_i2_bus_cntrl_reg <= (others => '0');
      socket_RF_i1_bus_cntrl_reg <= (others => '0');
      socket_RF_o1_bus_cntrl_reg <= (others => '0');
      socket_bool_i1_bus_cntrl_reg <= (others => '0');
      socket_bool_o1_bus_cntrl_reg <= (others => '0');
      socket_gcu_i1_bus_cntrl_reg <= (others => '0');
      socket_gcu_i2_bus_cntrl_reg <= (others => '0');
      socket_gcu_o1_bus_cntrl_reg <= (others => '0');
      socket_ALU_i1_bus_cntrl_reg <= (others => '0');
      socket_ALU_i2_bus_cntrl_reg <= (others => '0');
      socket_ALU_o1_bus_cntrl_reg <= (others => '0');
      socket_ADDSH_i1_bus_cntrl_reg <= (others => '0');
      socket_ADDSH_i2_bus_cntrl_reg <= (others => '0');
      socket_ADDSH_o1_bus_cntrl_reg <= (others => '0');
      socket_MUL_i1_bus_cntrl_reg <= (others => '0');
      socket_MUL_i2_bus_cntrl_reg <= (others => '0');
      socket_MUL_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_0_1_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_0_1_i1_bus_cntrl_reg <= (others => '0');
      socket_RF_0_2_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_0_2_i1_bus_cntrl_reg <= (others => '0');
      socket_RF_2_1_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_2_1_i1_bus_cntrl_reg <= (others => '0');
      socket_RF_2_2_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_2_2_i1_bus_cntrl_reg <= (others => '0');
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= (others => '0');
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg <= (others => '0');
      socket_INPUT_i1_bus_cntrl_reg <= (others => '0');
      socket_INPUT_o1_bus_cntrl_reg <= (others => '0');
      socket_INPUT_o2_bus_cntrl_reg <= (others => '0');
      socket_RF_5_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_5_i1_bus_cntrl_reg <= (others => '0');
      socket_ADDSH_1_i1_bus_cntrl_reg <= (others => '0');
      socket_ADDSH_1_i2_bus_cntrl_reg <= (others => '0');
      socket_ADDSH_1_o1_bus_cntrl_reg <= (others => '0');
      socket_MUL_1_i1_bus_cntrl_reg <= (others => '0');
      socket_MUL_1_i2_bus_cntrl_reg <= (others => '0');
      socket_MUL_1_o1_bus_cntrl_reg <= (others => '0');

      simm_cntrl_B1_reg <= (others => '0');
      simm_B1_reg <= (others => '0');
      simm_cntrl_B1_1_reg <= (others => '0');
      simm_B1_1_reg <= (others => '0');
      simm_cntrl_B1_2_reg <= (others => '0');
      simm_B1_2_reg <= (others => '0');
      simm_cntrl_B1_3_reg <= (others => '0');
      simm_B1_3_reg <= (others => '0');
      simm_cntrl_B1_4_reg <= (others => '0');
      simm_B1_4_reg <= (others => '0');
      simm_cntrl_B1_5_reg <= (others => '0');
      simm_B1_5_reg <= (others => '0');
      simm_cntrl_B1_6_reg <= (others => '0');
      simm_B1_6_reg <= (others => '0');
      simm_cntrl_B1_7_reg <= (others => '0');
      simm_B1_7_reg <= (others => '0');

      fu_LSU_opc_reg <= (others => '0');
      fu_LSU_in1t_load_reg <= '0';
      fu_LSU_in2_load_reg <= '0';
      fu_ALU_opc_reg <= (others => '0');
      fu_ALU_in1t_load_reg <= '0';
      fu_ALU_in2_load_reg <= '0';
      fu_ADDSH_opc_reg <= (others => '0');
      fu_ADDSH_in1t_load_reg <= '0';
      fu_ADDSH_in2_load_reg <= '0';
      fu_MUL_in1t_load_reg <= '0';
      fu_MUL_in2_load_reg <= '0';
      fu_OUTPUT_opc_reg <= (others => '0');
      fu_OUTPUT_in1t_load_reg <= '0';
      fu_INPUT_opc_reg <= (others => '0');
      fu_INPUT_in1t_load_reg <= '0';
      fu_ADDSH_1_opc_reg <= (others => '0');
      fu_ADDSH_1_in1t_load_reg <= '0';
      fu_ADDSH_1_in2_load_reg <= '0';
      fu_MUL_1_in1t_load_reg <= '0';
      fu_MUL_1_in2_load_reg <= '0';
      fu_gcu_opc_reg <= (others => '0');
      fu_gcu_pc_load_reg <= '0';
      fu_gcu_ra_load_reg <= '0';

      rf_RF_0_wr_load_reg <= '0';
      rf_RF_0_wr_opc_reg <= (others => '0');
      rf_RF_0_rd_load_reg <= '0';
      rf_RF_0_rd_opc_reg <= (others => '0');
      rf_BOOL_wr_load_reg <= '0';
      rf_BOOL_wr_opc_reg <= (others => '0');
      rf_BOOL_rd_load_reg <= '0';
      rf_BOOL_rd_opc_reg <= (others => '0');
      rf_RF_1_wr_load_reg <= '0';
      rf_RF_1_wr_opc_reg <= (others => '0');
      rf_RF_1_rd_load_reg <= '0';
      rf_RF_1_rd_opc_reg <= (others => '0');
      rf_RF_2_wr_load_reg <= '0';
      rf_RF_2_wr_opc_reg <= (others => '0');
      rf_RF_2_rd_load_reg <= '0';
      rf_RF_2_rd_opc_reg <= (others => '0');
      rf_RF_3_wr_load_reg <= '0';
      rf_RF_3_wr_opc_reg <= (others => '0');
      rf_RF_3_rd_load_reg <= '0';
      rf_RF_3_rd_opc_reg <= (others => '0');
      rf_RF_4_wr_load_reg <= '0';
      rf_RF_4_wr_opc_reg <= (others => '0');
      rf_RF_4_rd_load_reg <= '0';
      rf_RF_4_rd_opc_reg <= (others => '0');
      rf_RF_5_wr_load_reg <= '0';
      rf_RF_5_wr_opc_reg <= (others => '0');
      rf_RF_5_rd_load_reg <= '0';
      rf_RF_5_rd_opc_reg <= (others => '0');


    elsif (clk'event and clk = '1') then
      if (lock = '0') then -- rising clock edge

        --bus control signals for output sockets
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 40 and squash_B1_7 = '0') then
          socket_lsu_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 40 and squash_B1_6 = '0') then
          socket_lsu_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 40 and squash_B1_5 = '0') then
          socket_lsu_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 40 and squash_B1_4 = '0') then
          socket_lsu_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 40 and squash_B1_3 = '0') then
          socket_lsu_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 40 and squash_B1_2 = '0') then
          socket_lsu_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 40 and squash_B1_1 = '0') then
          socket_lsu_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 40 and squash_B1 = '0') then
          socket_lsu_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 32 and squash_B1_7 = '0') then
          socket_RF_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 32 and squash_B1_6 = '0') then
          socket_RF_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 32 and squash_B1_5 = '0') then
          socket_RF_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 32 and squash_B1_4 = '0') then
          socket_RF_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 32 and squash_B1_3 = '0') then
          socket_RF_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 32 and squash_B1_2 = '0') then
          socket_RF_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 32 and squash_B1_1 = '0') then
          socket_RF_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 32 and squash_B1 = '0') then
          socket_RF_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 38 and squash_B1_7 = '0') then
          socket_bool_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_bool_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 38 and squash_B1_6 = '0') then
          socket_bool_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_bool_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 38 and squash_B1_5 = '0') then
          socket_bool_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_bool_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 38 and squash_B1_4 = '0') then
          socket_bool_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_bool_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 38 and squash_B1_3 = '0') then
          socket_bool_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_bool_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 38 and squash_B1_2 = '0') then
          socket_bool_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_bool_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 38 and squash_B1_1 = '0') then
          socket_bool_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_bool_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 38 and squash_B1 = '0') then
          socket_bool_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_bool_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 41 and squash_B1_7 = '0') then
          socket_gcu_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 41 and squash_B1_6 = '0') then
          socket_gcu_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 41 and squash_B1_5 = '0') then
          socket_gcu_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 41 and squash_B1_4 = '0') then
          socket_gcu_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 41 and squash_B1_3 = '0') then
          socket_gcu_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 41 and squash_B1_2 = '0') then
          socket_gcu_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 41 and squash_B1_1 = '0') then
          socket_gcu_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 41 and squash_B1 = '0') then
          socket_gcu_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 42 and squash_B1_7 = '0') then
          socket_ALU_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 42 and squash_B1_6 = '0') then
          socket_ALU_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 42 and squash_B1_5 = '0') then
          socket_ALU_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 42 and squash_B1_4 = '0') then
          socket_ALU_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 42 and squash_B1_3 = '0') then
          socket_ALU_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 42 and squash_B1_2 = '0') then
          socket_ALU_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 42 and squash_B1_1 = '0') then
          socket_ALU_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 42 and squash_B1 = '0') then
          socket_ALU_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 43 and squash_B1_7 = '0') then
          socket_ADDSH_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_ADDSH_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 43 and squash_B1_6 = '0') then
          socket_ADDSH_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_ADDSH_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 43 and squash_B1_5 = '0') then
          socket_ADDSH_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_ADDSH_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 43 and squash_B1_4 = '0') then
          socket_ADDSH_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_ADDSH_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 43 and squash_B1_3 = '0') then
          socket_ADDSH_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_ADDSH_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 43 and squash_B1_2 = '0') then
          socket_ADDSH_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_ADDSH_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 43 and squash_B1_1 = '0') then
          socket_ADDSH_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_ADDSH_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 43 and squash_B1 = '0') then
          socket_ADDSH_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_ADDSH_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 44 and squash_B1_7 = '0') then
          socket_MUL_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_MUL_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 44 and squash_B1_6 = '0') then
          socket_MUL_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_MUL_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 44 and squash_B1_5 = '0') then
          socket_MUL_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_MUL_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 44 and squash_B1_4 = '0') then
          socket_MUL_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_MUL_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 44 and squash_B1_3 = '0') then
          socket_MUL_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_MUL_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 44 and squash_B1_2 = '0') then
          socket_MUL_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_MUL_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 44 and squash_B1_1 = '0') then
          socket_MUL_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_MUL_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 44 and squash_B1 = '0') then
          socket_MUL_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_MUL_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 33 and squash_B1_7 = '0') then
          socket_RF_0_1_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_RF_0_1_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 33 and squash_B1_6 = '0') then
          socket_RF_0_1_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_RF_0_1_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 33 and squash_B1_5 = '0') then
          socket_RF_0_1_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_RF_0_1_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 33 and squash_B1_4 = '0') then
          socket_RF_0_1_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_RF_0_1_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 33 and squash_B1_3 = '0') then
          socket_RF_0_1_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_RF_0_1_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 33 and squash_B1_2 = '0') then
          socket_RF_0_1_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_RF_0_1_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 33 and squash_B1_1 = '0') then
          socket_RF_0_1_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_0_1_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 33 and squash_B1 = '0') then
          socket_RF_0_1_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_0_1_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 34 and squash_B1_7 = '0') then
          socket_RF_0_2_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_RF_0_2_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 34 and squash_B1_6 = '0') then
          socket_RF_0_2_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_RF_0_2_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 34 and squash_B1_5 = '0') then
          socket_RF_0_2_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_RF_0_2_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 34 and squash_B1_4 = '0') then
          socket_RF_0_2_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_RF_0_2_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 34 and squash_B1_3 = '0') then
          socket_RF_0_2_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_RF_0_2_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 34 and squash_B1_2 = '0') then
          socket_RF_0_2_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_RF_0_2_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 34 and squash_B1_1 = '0') then
          socket_RF_0_2_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_0_2_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 34 and squash_B1 = '0') then
          socket_RF_0_2_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_0_2_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 35 and squash_B1_7 = '0') then
          socket_RF_2_1_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_RF_2_1_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 35 and squash_B1_6 = '0') then
          socket_RF_2_1_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_RF_2_1_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 35 and squash_B1_5 = '0') then
          socket_RF_2_1_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_RF_2_1_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 35 and squash_B1_4 = '0') then
          socket_RF_2_1_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_RF_2_1_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 35 and squash_B1_3 = '0') then
          socket_RF_2_1_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_RF_2_1_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 35 and squash_B1_2 = '0') then
          socket_RF_2_1_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_RF_2_1_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 35 and squash_B1_1 = '0') then
          socket_RF_2_1_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_2_1_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 35 and squash_B1 = '0') then
          socket_RF_2_1_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_2_1_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 36 and squash_B1_7 = '0') then
          socket_RF_2_2_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_RF_2_2_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 36 and squash_B1_6 = '0') then
          socket_RF_2_2_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_RF_2_2_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 36 and squash_B1_5 = '0') then
          socket_RF_2_2_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_RF_2_2_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 36 and squash_B1_4 = '0') then
          socket_RF_2_2_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_RF_2_2_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 36 and squash_B1_3 = '0') then
          socket_RF_2_2_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_RF_2_2_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 36 and squash_B1_2 = '0') then
          socket_RF_2_2_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_RF_2_2_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 36 and squash_B1_1 = '0') then
          socket_RF_2_2_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_2_2_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 36 and squash_B1 = '0') then
          socket_RF_2_2_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_2_2_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 45 and squash_B1_7 = '0') then
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(7) <= '1';
        else
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 45 and squash_B1_6 = '0') then
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(6) <= '1';
        else
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 45 and squash_B1_5 = '0') then
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(5) <= '1';
        else
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 45 and squash_B1_4 = '0') then
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(4) <= '1';
        else
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 45 and squash_B1_3 = '0') then
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(3) <= '1';
        else
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 45 and squash_B1_2 = '0') then
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(2) <= '1';
        else
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 45 and squash_B1_1 = '0') then
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(1) <= '1';
        else
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 45 and squash_B1 = '0') then
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(0) <= '1';
        else
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 46 and squash_B1_7 = '0') then
          socket_INPUT_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_INPUT_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 46 and squash_B1_6 = '0') then
          socket_INPUT_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_INPUT_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 46 and squash_B1_5 = '0') then
          socket_INPUT_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_INPUT_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 46 and squash_B1_4 = '0') then
          socket_INPUT_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_INPUT_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 46 and squash_B1_3 = '0') then
          socket_INPUT_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_INPUT_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 46 and squash_B1_2 = '0') then
          socket_INPUT_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_INPUT_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 46 and squash_B1_1 = '0') then
          socket_INPUT_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_INPUT_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 46 and squash_B1 = '0') then
          socket_INPUT_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_INPUT_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 47 and squash_B1_7 = '0') then
          socket_INPUT_o2_bus_cntrl_reg(7) <= '1';
        else
          socket_INPUT_o2_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 47 and squash_B1_6 = '0') then
          socket_INPUT_o2_bus_cntrl_reg(6) <= '1';
        else
          socket_INPUT_o2_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 47 and squash_B1_5 = '0') then
          socket_INPUT_o2_bus_cntrl_reg(5) <= '1';
        else
          socket_INPUT_o2_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 47 and squash_B1_4 = '0') then
          socket_INPUT_o2_bus_cntrl_reg(4) <= '1';
        else
          socket_INPUT_o2_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 47 and squash_B1_3 = '0') then
          socket_INPUT_o2_bus_cntrl_reg(3) <= '1';
        else
          socket_INPUT_o2_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 47 and squash_B1_2 = '0') then
          socket_INPUT_o2_bus_cntrl_reg(2) <= '1';
        else
          socket_INPUT_o2_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 47 and squash_B1_1 = '0') then
          socket_INPUT_o2_bus_cntrl_reg(1) <= '1';
        else
          socket_INPUT_o2_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 47 and squash_B1 = '0') then
          socket_INPUT_o2_bus_cntrl_reg(0) <= '1';
        else
          socket_INPUT_o2_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 37 and squash_B1_7 = '0') then
          socket_RF_5_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_RF_5_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 37 and squash_B1_6 = '0') then
          socket_RF_5_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_RF_5_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 37 and squash_B1_5 = '0') then
          socket_RF_5_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_RF_5_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 37 and squash_B1_4 = '0') then
          socket_RF_5_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_RF_5_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 37 and squash_B1_3 = '0') then
          socket_RF_5_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_RF_5_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 37 and squash_B1_2 = '0') then
          socket_RF_5_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_RF_5_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 37 and squash_B1_1 = '0') then
          socket_RF_5_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_5_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 37 and squash_B1 = '0') then
          socket_RF_5_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_5_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 48 and squash_B1_7 = '0') then
          socket_ADDSH_1_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_ADDSH_1_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 48 and squash_B1_6 = '0') then
          socket_ADDSH_1_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_ADDSH_1_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 48 and squash_B1_5 = '0') then
          socket_ADDSH_1_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_ADDSH_1_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 48 and squash_B1_4 = '0') then
          socket_ADDSH_1_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_ADDSH_1_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 48 and squash_B1_3 = '0') then
          socket_ADDSH_1_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_ADDSH_1_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 48 and squash_B1_2 = '0') then
          socket_ADDSH_1_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_ADDSH_1_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 48 and squash_B1_1 = '0') then
          socket_ADDSH_1_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_ADDSH_1_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 48 and squash_B1 = '0') then
          socket_ADDSH_1_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_ADDSH_1_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 49 and squash_B1_7 = '0') then
          socket_MUL_1_o1_bus_cntrl_reg(7) <= '1';
        else
          socket_MUL_1_o1_bus_cntrl_reg(7) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 27))) = 49 and squash_B1_6 = '0') then
          socket_MUL_1_o1_bus_cntrl_reg(6) <= '1';
        else
          socket_MUL_1_o1_bus_cntrl_reg(6) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 27))) = 49 and squash_B1_5 = '0') then
          socket_MUL_1_o1_bus_cntrl_reg(5) <= '1';
        else
          socket_MUL_1_o1_bus_cntrl_reg(5) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 27))) = 49 and squash_B1_4 = '0') then
          socket_MUL_1_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_MUL_1_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 27))) = 49 and squash_B1_3 = '0') then
          socket_MUL_1_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_MUL_1_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 27))) = 49 and squash_B1_2 = '0') then
          socket_MUL_1_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_MUL_1_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 27))) = 49 and squash_B1_1 = '0') then
          socket_MUL_1_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_MUL_1_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1(32 downto 27))) = 49 and squash_B1 = '0') then
          socket_MUL_1_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_MUL_1_o1_bus_cntrl_reg(0) <= '0';
        end if;

        --bus control signals for short immediate sockets
        if (conv_integer(unsigned(src_B1(32 downto 32))) = 0 and squash_B1 = '0') then
          simm_cntrl_B1_reg(0) <= '1';
          simm_B1_reg <= ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_1(32 downto 32))) = 0 and squash_B1_1 = '0') then
          simm_cntrl_B1_1_reg(0) <= '1';
          simm_B1_1_reg <= ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_2(32 downto 32))) = 0 and squash_B1_2 = '0') then
          simm_cntrl_B1_2_reg(0) <= '1';
          simm_B1_2_reg <= ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_3(32 downto 32))) = 0 and squash_B1_3 = '0') then
          simm_cntrl_B1_3_reg(0) <= '1';
          simm_B1_3_reg <= ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_4(32 downto 32))) = 0 and squash_B1_4 = '0') then
          simm_cntrl_B1_4_reg(0) <= '1';
          simm_B1_4_reg <= ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_5(32 downto 32))) = 0 and squash_B1_5 = '0') then
          simm_cntrl_B1_5_reg(0) <= '1';
          simm_B1_5_reg <= ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_6(32 downto 32))) = 0 and squash_B1_6 = '0') then
          simm_cntrl_B1_6_reg(0) <= '1';
          simm_B1_6_reg <= ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 32))) = 0 and squash_B1_7 = '0') then
          simm_cntrl_B1_7_reg(0) <= '1';
          simm_B1_7_reg <= ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;

        --data control signals for output sockets connected to FUs

        --control signals for RF read ports
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 32 and squash_B1_7 = '0') then
          rf_RF_0_rd_load_reg <= '1';
          rf_RF_0_rd_opc_reg <= ext(src_B1_7(2 downto 0), rf_RF_0_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_6(32 downto 27))) = 32 and squash_B1_6 = '0') then
          rf_RF_0_rd_load_reg <= '1';
          rf_RF_0_rd_opc_reg <= ext(src_B1_6(2 downto 0), rf_RF_0_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_5(32 downto 27))) = 32 and squash_B1_5 = '0') then
          rf_RF_0_rd_load_reg <= '1';
          rf_RF_0_rd_opc_reg <= ext(src_B1_5(2 downto 0), rf_RF_0_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_4(32 downto 27))) = 32 and squash_B1_4 = '0') then
          rf_RF_0_rd_load_reg <= '1';
          rf_RF_0_rd_opc_reg <= ext(src_B1_4(2 downto 0), rf_RF_0_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_3(32 downto 27))) = 32 and squash_B1_3 = '0') then
          rf_RF_0_rd_load_reg <= '1';
          rf_RF_0_rd_opc_reg <= ext(src_B1_3(2 downto 0), rf_RF_0_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_2(32 downto 27))) = 32 and squash_B1_2 = '0') then
          rf_RF_0_rd_load_reg <= '1';
          rf_RF_0_rd_opc_reg <= ext(src_B1_2(2 downto 0), rf_RF_0_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_1(32 downto 27))) = 32 and squash_B1_1 = '0') then
          rf_RF_0_rd_load_reg <= '1';
          rf_RF_0_rd_opc_reg <= ext(src_B1_1(2 downto 0), rf_RF_0_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1(32 downto 27))) = 32 and squash_B1 = '0') then
          rf_RF_0_rd_load_reg <= '1';
          rf_RF_0_rd_opc_reg <= ext(src_B1(2 downto 0), rf_RF_0_rd_opc_reg'length);
        else
          rf_RF_0_rd_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 38 and squash_B1_7 = '0') then
          rf_BOOL_rd_load_reg <= '1';
          rf_BOOL_rd_opc_reg <= ext(src_B1_7(0 downto 0), rf_BOOL_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_6(32 downto 27))) = 38 and squash_B1_6 = '0') then
          rf_BOOL_rd_load_reg <= '1';
          rf_BOOL_rd_opc_reg <= ext(src_B1_6(0 downto 0), rf_BOOL_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_5(32 downto 27))) = 38 and squash_B1_5 = '0') then
          rf_BOOL_rd_load_reg <= '1';
          rf_BOOL_rd_opc_reg <= ext(src_B1_5(0 downto 0), rf_BOOL_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_4(32 downto 27))) = 38 and squash_B1_4 = '0') then
          rf_BOOL_rd_load_reg <= '1';
          rf_BOOL_rd_opc_reg <= ext(src_B1_4(0 downto 0), rf_BOOL_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_3(32 downto 27))) = 38 and squash_B1_3 = '0') then
          rf_BOOL_rd_load_reg <= '1';
          rf_BOOL_rd_opc_reg <= ext(src_B1_3(0 downto 0), rf_BOOL_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_2(32 downto 27))) = 38 and squash_B1_2 = '0') then
          rf_BOOL_rd_load_reg <= '1';
          rf_BOOL_rd_opc_reg <= ext(src_B1_2(0 downto 0), rf_BOOL_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_1(32 downto 27))) = 38 and squash_B1_1 = '0') then
          rf_BOOL_rd_load_reg <= '1';
          rf_BOOL_rd_opc_reg <= ext(src_B1_1(0 downto 0), rf_BOOL_rd_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1(32 downto 27))) = 38 and squash_B1 = '0') then
          rf_BOOL_rd_load_reg <= '1';
          rf_BOOL_rd_opc_reg <= ext(src_B1(0 downto 0), rf_BOOL_rd_opc_reg'length);
        else
          rf_BOOL_rd_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 33 and squash_B1_7 = '0') then
          rf_RF_1_wr_load_reg <= '1';
          rf_RF_1_wr_opc_reg <= ext(src_B1_7(2 downto 0), rf_RF_1_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_6(32 downto 27))) = 33 and squash_B1_6 = '0') then
          rf_RF_1_wr_load_reg <= '1';
          rf_RF_1_wr_opc_reg <= ext(src_B1_6(2 downto 0), rf_RF_1_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_5(32 downto 27))) = 33 and squash_B1_5 = '0') then
          rf_RF_1_wr_load_reg <= '1';
          rf_RF_1_wr_opc_reg <= ext(src_B1_5(2 downto 0), rf_RF_1_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_4(32 downto 27))) = 33 and squash_B1_4 = '0') then
          rf_RF_1_wr_load_reg <= '1';
          rf_RF_1_wr_opc_reg <= ext(src_B1_4(2 downto 0), rf_RF_1_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_3(32 downto 27))) = 33 and squash_B1_3 = '0') then
          rf_RF_1_wr_load_reg <= '1';
          rf_RF_1_wr_opc_reg <= ext(src_B1_3(2 downto 0), rf_RF_1_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_2(32 downto 27))) = 33 and squash_B1_2 = '0') then
          rf_RF_1_wr_load_reg <= '1';
          rf_RF_1_wr_opc_reg <= ext(src_B1_2(2 downto 0), rf_RF_1_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_1(32 downto 27))) = 33 and squash_B1_1 = '0') then
          rf_RF_1_wr_load_reg <= '1';
          rf_RF_1_wr_opc_reg <= ext(src_B1_1(2 downto 0), rf_RF_1_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1(32 downto 27))) = 33 and squash_B1 = '0') then
          rf_RF_1_wr_load_reg <= '1';
          rf_RF_1_wr_opc_reg <= ext(src_B1(2 downto 0), rf_RF_1_wr_opc_reg'length);
        else
          rf_RF_1_wr_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 34 and squash_B1_7 = '0') then
          rf_RF_2_wr_load_reg <= '1';
          rf_RF_2_wr_opc_reg <= ext(src_B1_7(2 downto 0), rf_RF_2_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_6(32 downto 27))) = 34 and squash_B1_6 = '0') then
          rf_RF_2_wr_load_reg <= '1';
          rf_RF_2_wr_opc_reg <= ext(src_B1_6(2 downto 0), rf_RF_2_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_5(32 downto 27))) = 34 and squash_B1_5 = '0') then
          rf_RF_2_wr_load_reg <= '1';
          rf_RF_2_wr_opc_reg <= ext(src_B1_5(2 downto 0), rf_RF_2_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_4(32 downto 27))) = 34 and squash_B1_4 = '0') then
          rf_RF_2_wr_load_reg <= '1';
          rf_RF_2_wr_opc_reg <= ext(src_B1_4(2 downto 0), rf_RF_2_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_3(32 downto 27))) = 34 and squash_B1_3 = '0') then
          rf_RF_2_wr_load_reg <= '1';
          rf_RF_2_wr_opc_reg <= ext(src_B1_3(2 downto 0), rf_RF_2_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_2(32 downto 27))) = 34 and squash_B1_2 = '0') then
          rf_RF_2_wr_load_reg <= '1';
          rf_RF_2_wr_opc_reg <= ext(src_B1_2(2 downto 0), rf_RF_2_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_1(32 downto 27))) = 34 and squash_B1_1 = '0') then
          rf_RF_2_wr_load_reg <= '1';
          rf_RF_2_wr_opc_reg <= ext(src_B1_1(2 downto 0), rf_RF_2_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1(32 downto 27))) = 34 and squash_B1 = '0') then
          rf_RF_2_wr_load_reg <= '1';
          rf_RF_2_wr_opc_reg <= ext(src_B1(2 downto 0), rf_RF_2_wr_opc_reg'length);
        else
          rf_RF_2_wr_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 35 and squash_B1_7 = '0') then
          rf_RF_3_wr_load_reg <= '1';
          rf_RF_3_wr_opc_reg <= ext(src_B1_7(2 downto 0), rf_RF_3_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_6(32 downto 27))) = 35 and squash_B1_6 = '0') then
          rf_RF_3_wr_load_reg <= '1';
          rf_RF_3_wr_opc_reg <= ext(src_B1_6(2 downto 0), rf_RF_3_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_5(32 downto 27))) = 35 and squash_B1_5 = '0') then
          rf_RF_3_wr_load_reg <= '1';
          rf_RF_3_wr_opc_reg <= ext(src_B1_5(2 downto 0), rf_RF_3_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_4(32 downto 27))) = 35 and squash_B1_4 = '0') then
          rf_RF_3_wr_load_reg <= '1';
          rf_RF_3_wr_opc_reg <= ext(src_B1_4(2 downto 0), rf_RF_3_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_3(32 downto 27))) = 35 and squash_B1_3 = '0') then
          rf_RF_3_wr_load_reg <= '1';
          rf_RF_3_wr_opc_reg <= ext(src_B1_3(2 downto 0), rf_RF_3_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_2(32 downto 27))) = 35 and squash_B1_2 = '0') then
          rf_RF_3_wr_load_reg <= '1';
          rf_RF_3_wr_opc_reg <= ext(src_B1_2(2 downto 0), rf_RF_3_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_1(32 downto 27))) = 35 and squash_B1_1 = '0') then
          rf_RF_3_wr_load_reg <= '1';
          rf_RF_3_wr_opc_reg <= ext(src_B1_1(2 downto 0), rf_RF_3_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1(32 downto 27))) = 35 and squash_B1 = '0') then
          rf_RF_3_wr_load_reg <= '1';
          rf_RF_3_wr_opc_reg <= ext(src_B1(2 downto 0), rf_RF_3_wr_opc_reg'length);
        else
          rf_RF_3_wr_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 36 and squash_B1_7 = '0') then
          rf_RF_4_wr_load_reg <= '1';
          rf_RF_4_wr_opc_reg <= ext(src_B1_7(2 downto 0), rf_RF_4_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_6(32 downto 27))) = 36 and squash_B1_6 = '0') then
          rf_RF_4_wr_load_reg <= '1';
          rf_RF_4_wr_opc_reg <= ext(src_B1_6(2 downto 0), rf_RF_4_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_5(32 downto 27))) = 36 and squash_B1_5 = '0') then
          rf_RF_4_wr_load_reg <= '1';
          rf_RF_4_wr_opc_reg <= ext(src_B1_5(2 downto 0), rf_RF_4_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_4(32 downto 27))) = 36 and squash_B1_4 = '0') then
          rf_RF_4_wr_load_reg <= '1';
          rf_RF_4_wr_opc_reg <= ext(src_B1_4(2 downto 0), rf_RF_4_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_3(32 downto 27))) = 36 and squash_B1_3 = '0') then
          rf_RF_4_wr_load_reg <= '1';
          rf_RF_4_wr_opc_reg <= ext(src_B1_3(2 downto 0), rf_RF_4_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_2(32 downto 27))) = 36 and squash_B1_2 = '0') then
          rf_RF_4_wr_load_reg <= '1';
          rf_RF_4_wr_opc_reg <= ext(src_B1_2(2 downto 0), rf_RF_4_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_1(32 downto 27))) = 36 and squash_B1_1 = '0') then
          rf_RF_4_wr_load_reg <= '1';
          rf_RF_4_wr_opc_reg <= ext(src_B1_1(2 downto 0), rf_RF_4_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1(32 downto 27))) = 36 and squash_B1 = '0') then
          rf_RF_4_wr_load_reg <= '1';
          rf_RF_4_wr_opc_reg <= ext(src_B1(2 downto 0), rf_RF_4_wr_opc_reg'length);
        else
          rf_RF_4_wr_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(src_B1_7(32 downto 27))) = 37 and squash_B1_7 = '0') then
          rf_RF_5_wr_load_reg <= '1';
          rf_RF_5_wr_opc_reg <= ext(src_B1_7(2 downto 0), rf_RF_5_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_6(32 downto 27))) = 37 and squash_B1_6 = '0') then
          rf_RF_5_wr_load_reg <= '1';
          rf_RF_5_wr_opc_reg <= ext(src_B1_6(2 downto 0), rf_RF_5_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_5(32 downto 27))) = 37 and squash_B1_5 = '0') then
          rf_RF_5_wr_load_reg <= '1';
          rf_RF_5_wr_opc_reg <= ext(src_B1_5(2 downto 0), rf_RF_5_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_4(32 downto 27))) = 37 and squash_B1_4 = '0') then
          rf_RF_5_wr_load_reg <= '1';
          rf_RF_5_wr_opc_reg <= ext(src_B1_4(2 downto 0), rf_RF_5_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_3(32 downto 27))) = 37 and squash_B1_3 = '0') then
          rf_RF_5_wr_load_reg <= '1';
          rf_RF_5_wr_opc_reg <= ext(src_B1_3(2 downto 0), rf_RF_5_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_2(32 downto 27))) = 37 and squash_B1_2 = '0') then
          rf_RF_5_wr_load_reg <= '1';
          rf_RF_5_wr_opc_reg <= ext(src_B1_2(2 downto 0), rf_RF_5_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1_1(32 downto 27))) = 37 and squash_B1_1 = '0') then
          rf_RF_5_wr_load_reg <= '1';
          rf_RF_5_wr_opc_reg <= ext(src_B1_1(2 downto 0), rf_RF_5_wr_opc_reg'length);
        elsif (conv_integer(unsigned(src_B1(32 downto 27))) = 37 and squash_B1 = '0') then
          rf_RF_5_wr_load_reg <= '1';
          rf_RF_5_wr_opc_reg <= ext(src_B1(2 downto 0), rf_RF_5_wr_opc_reg'length);
        else
          rf_RF_5_wr_load_reg <= '0';
        end if;

        --control signals for IU read ports

        --control signals for FU inputs
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 2 and squash_B1_7 = '0') then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1_7(2 downto 0);
          socket_lsu_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_lsu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 2 and squash_B1_6 = '0') then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1_6(2 downto 0);
          socket_lsu_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_lsu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 2 and squash_B1_5 = '0') then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1_5(2 downto 0);
          socket_lsu_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_lsu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 2 and squash_B1_4 = '0') then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1_4(2 downto 0);
          socket_lsu_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_lsu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 2 and squash_B1_3 = '0') then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1_3(2 downto 0);
          socket_lsu_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_lsu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 2 and squash_B1_2 = '0') then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1_2(2 downto 0);
          socket_lsu_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_lsu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 2 and squash_B1_1 = '0') then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1_1(2 downto 0);
          socket_lsu_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_lsu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 2 and squash_B1 = '0') then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1(2 downto 0);
          socket_lsu_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_lsu_i1_bus_cntrl_reg'length);
        else
          fu_LSU_in1t_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 97 and squash_B1_7 = '0') then
          fu_LSU_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(7, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 97 and squash_B1_6 = '0') then
          fu_LSU_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(6, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 97 and squash_B1_5 = '0') then
          fu_LSU_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(5, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 97 and squash_B1_4 = '0') then
          fu_LSU_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(4, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 97 and squash_B1_3 = '0') then
          fu_LSU_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 97 and squash_B1_2 = '0') then
          fu_LSU_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 97 and squash_B1_1 = '0') then
          fu_LSU_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 97 and squash_B1 = '0') then
          fu_LSU_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_lsu_i2_bus_cntrl_reg'length);
        else
          fu_LSU_in2_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 4))) = 0 and squash_B1_7 = '0') then
          fu_ALU_in1t_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1_7(3 downto 0);
          socket_ALU_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_ALU_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 4))) = 0 and squash_B1_6 = '0') then
          fu_ALU_in1t_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1_6(3 downto 0);
          socket_ALU_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_ALU_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 4))) = 0 and squash_B1_5 = '0') then
          fu_ALU_in1t_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1_5(3 downto 0);
          socket_ALU_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_ALU_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 4))) = 0 and squash_B1_4 = '0') then
          fu_ALU_in1t_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1_4(3 downto 0);
          socket_ALU_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_ALU_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 4))) = 0 and squash_B1_3 = '0') then
          fu_ALU_in1t_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1_3(3 downto 0);
          socket_ALU_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_ALU_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 4))) = 0 and squash_B1_2 = '0') then
          fu_ALU_in1t_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1_2(3 downto 0);
          socket_ALU_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_ALU_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 4))) = 0 and squash_B1_1 = '0') then
          fu_ALU_in1t_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1_1(3 downto 0);
          socket_ALU_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_ALU_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 4))) = 0 and squash_B1 = '0') then
          fu_ALU_in1t_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1(3 downto 0);
          socket_ALU_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_ALU_i1_bus_cntrl_reg'length);
        else
          fu_ALU_in1t_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 99 and squash_B1_7 = '0') then
          fu_ALU_in2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(7, socket_ALU_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 99 and squash_B1_6 = '0') then
          fu_ALU_in2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(6, socket_ALU_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 99 and squash_B1_5 = '0') then
          fu_ALU_in2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(5, socket_ALU_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 99 and squash_B1_4 = '0') then
          fu_ALU_in2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(4, socket_ALU_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 99 and squash_B1_3 = '0') then
          fu_ALU_in2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_ALU_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 99 and squash_B1_2 = '0') then
          fu_ALU_in2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_ALU_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 99 and squash_B1_1 = '0') then
          fu_ALU_in2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_ALU_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 99 and squash_B1 = '0') then
          fu_ALU_in2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_ALU_i2_bus_cntrl_reg'length);
        else
          fu_ALU_in2_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 4 and squash_B1_7 = '0') then
          fu_ADDSH_in1t_load_reg <= '1';
          fu_ADDSH_opc_reg <= dst_B1_7(2 downto 0);
          socket_ADDSH_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_ADDSH_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 4 and squash_B1_6 = '0') then
          fu_ADDSH_in1t_load_reg <= '1';
          fu_ADDSH_opc_reg <= dst_B1_6(2 downto 0);
          socket_ADDSH_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_ADDSH_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 4 and squash_B1_5 = '0') then
          fu_ADDSH_in1t_load_reg <= '1';
          fu_ADDSH_opc_reg <= dst_B1_5(2 downto 0);
          socket_ADDSH_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_ADDSH_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 4 and squash_B1_4 = '0') then
          fu_ADDSH_in1t_load_reg <= '1';
          fu_ADDSH_opc_reg <= dst_B1_4(2 downto 0);
          socket_ADDSH_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_ADDSH_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 4 and squash_B1_3 = '0') then
          fu_ADDSH_in1t_load_reg <= '1';
          fu_ADDSH_opc_reg <= dst_B1_3(2 downto 0);
          socket_ADDSH_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_ADDSH_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 4 and squash_B1_2 = '0') then
          fu_ADDSH_in1t_load_reg <= '1';
          fu_ADDSH_opc_reg <= dst_B1_2(2 downto 0);
          socket_ADDSH_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_ADDSH_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 4 and squash_B1_1 = '0') then
          fu_ADDSH_in1t_load_reg <= '1';
          fu_ADDSH_opc_reg <= dst_B1_1(2 downto 0);
          socket_ADDSH_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_ADDSH_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 4 and squash_B1 = '0') then
          fu_ADDSH_in1t_load_reg <= '1';
          fu_ADDSH_opc_reg <= dst_B1(2 downto 0);
          socket_ADDSH_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_ADDSH_i1_bus_cntrl_reg'length);
        else
          fu_ADDSH_in1t_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 100 and squash_B1_7 = '0') then
          fu_ADDSH_in2_load_reg <= '1';
          socket_ADDSH_i2_bus_cntrl_reg <= conv_std_logic_vector(7, socket_ADDSH_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 100 and squash_B1_6 = '0') then
          fu_ADDSH_in2_load_reg <= '1';
          socket_ADDSH_i2_bus_cntrl_reg <= conv_std_logic_vector(6, socket_ADDSH_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 100 and squash_B1_5 = '0') then
          fu_ADDSH_in2_load_reg <= '1';
          socket_ADDSH_i2_bus_cntrl_reg <= conv_std_logic_vector(5, socket_ADDSH_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 100 and squash_B1_4 = '0') then
          fu_ADDSH_in2_load_reg <= '1';
          socket_ADDSH_i2_bus_cntrl_reg <= conv_std_logic_vector(4, socket_ADDSH_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 100 and squash_B1_3 = '0') then
          fu_ADDSH_in2_load_reg <= '1';
          socket_ADDSH_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_ADDSH_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 100 and squash_B1_2 = '0') then
          fu_ADDSH_in2_load_reg <= '1';
          socket_ADDSH_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_ADDSH_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 100 and squash_B1_1 = '0') then
          fu_ADDSH_in2_load_reg <= '1';
          socket_ADDSH_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_ADDSH_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 100 and squash_B1 = '0') then
          fu_ADDSH_in2_load_reg <= '1';
          socket_ADDSH_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_ADDSH_i2_bus_cntrl_reg'length);
        else
          fu_ADDSH_in2_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 101 and squash_B1_7 = '0') then
          fu_MUL_in1t_load_reg <= '1';
          socket_MUL_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_MUL_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 101 and squash_B1_6 = '0') then
          fu_MUL_in1t_load_reg <= '1';
          socket_MUL_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_MUL_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 101 and squash_B1_5 = '0') then
          fu_MUL_in1t_load_reg <= '1';
          socket_MUL_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_MUL_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 101 and squash_B1_4 = '0') then
          fu_MUL_in1t_load_reg <= '1';
          socket_MUL_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_MUL_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 101 and squash_B1_3 = '0') then
          fu_MUL_in1t_load_reg <= '1';
          socket_MUL_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_MUL_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 101 and squash_B1_2 = '0') then
          fu_MUL_in1t_load_reg <= '1';
          socket_MUL_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_MUL_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 101 and squash_B1_1 = '0') then
          fu_MUL_in1t_load_reg <= '1';
          socket_MUL_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_MUL_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 101 and squash_B1 = '0') then
          fu_MUL_in1t_load_reg <= '1';
          socket_MUL_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_MUL_i1_bus_cntrl_reg'length);
        else
          fu_MUL_in1t_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 102 and squash_B1_7 = '0') then
          fu_MUL_in2_load_reg <= '1';
          socket_MUL_i2_bus_cntrl_reg <= conv_std_logic_vector(7, socket_MUL_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 102 and squash_B1_6 = '0') then
          fu_MUL_in2_load_reg <= '1';
          socket_MUL_i2_bus_cntrl_reg <= conv_std_logic_vector(6, socket_MUL_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 102 and squash_B1_5 = '0') then
          fu_MUL_in2_load_reg <= '1';
          socket_MUL_i2_bus_cntrl_reg <= conv_std_logic_vector(5, socket_MUL_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 102 and squash_B1_4 = '0') then
          fu_MUL_in2_load_reg <= '1';
          socket_MUL_i2_bus_cntrl_reg <= conv_std_logic_vector(4, socket_MUL_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 102 and squash_B1_3 = '0') then
          fu_MUL_in2_load_reg <= '1';
          socket_MUL_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_MUL_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 102 and squash_B1_2 = '0') then
          fu_MUL_in2_load_reg <= '1';
          socket_MUL_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_MUL_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 102 and squash_B1_1 = '0') then
          fu_MUL_in2_load_reg <= '1';
          socket_MUL_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_MUL_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 102 and squash_B1 = '0') then
          fu_MUL_in2_load_reg <= '1';
          socket_MUL_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_MUL_i2_bus_cntrl_reg'length);
        else
          fu_MUL_in2_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 1))) = 46 and squash_B1_7 = '0') then
          fu_OUTPUT_in1t_load_reg <= '1';
          fu_OUTPUT_opc_reg <= dst_B1_7(0 downto 0);
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= conv_std_logic_vector(7, socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 1))) = 46 and squash_B1_6 = '0') then
          fu_OUTPUT_in1t_load_reg <= '1';
          fu_OUTPUT_opc_reg <= dst_B1_6(0 downto 0);
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= conv_std_logic_vector(6, socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 1))) = 46 and squash_B1_5 = '0') then
          fu_OUTPUT_in1t_load_reg <= '1';
          fu_OUTPUT_opc_reg <= dst_B1_5(0 downto 0);
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= conv_std_logic_vector(5, socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 1))) = 46 and squash_B1_4 = '0') then
          fu_OUTPUT_in1t_load_reg <= '1';
          fu_OUTPUT_opc_reg <= dst_B1_4(0 downto 0);
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= conv_std_logic_vector(4, socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 1))) = 46 and squash_B1_3 = '0') then
          fu_OUTPUT_in1t_load_reg <= '1';
          fu_OUTPUT_opc_reg <= dst_B1_3(0 downto 0);
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 1))) = 46 and squash_B1_2 = '0') then
          fu_OUTPUT_in1t_load_reg <= '1';
          fu_OUTPUT_opc_reg <= dst_B1_2(0 downto 0);
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 1))) = 46 and squash_B1_1 = '0') then
          fu_OUTPUT_in1t_load_reg <= '1';
          fu_OUTPUT_opc_reg <= dst_B1_1(0 downto 0);
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 1))) = 46 and squash_B1 = '0') then
          fu_OUTPUT_in1t_load_reg <= '1';
          fu_OUTPUT_opc_reg <= dst_B1(0 downto 0);
          socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_reg'length);
        else
          fu_OUTPUT_in1t_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 1))) = 47 and squash_B1_7 = '0') then
          fu_INPUT_in1t_load_reg <= '1';
          fu_INPUT_opc_reg <= dst_B1_7(0 downto 0);
          socket_INPUT_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_INPUT_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 1))) = 47 and squash_B1_6 = '0') then
          fu_INPUT_in1t_load_reg <= '1';
          fu_INPUT_opc_reg <= dst_B1_6(0 downto 0);
          socket_INPUT_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_INPUT_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 1))) = 47 and squash_B1_5 = '0') then
          fu_INPUT_in1t_load_reg <= '1';
          fu_INPUT_opc_reg <= dst_B1_5(0 downto 0);
          socket_INPUT_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_INPUT_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 1))) = 47 and squash_B1_4 = '0') then
          fu_INPUT_in1t_load_reg <= '1';
          fu_INPUT_opc_reg <= dst_B1_4(0 downto 0);
          socket_INPUT_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_INPUT_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 1))) = 47 and squash_B1_3 = '0') then
          fu_INPUT_in1t_load_reg <= '1';
          fu_INPUT_opc_reg <= dst_B1_3(0 downto 0);
          socket_INPUT_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_INPUT_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 1))) = 47 and squash_B1_2 = '0') then
          fu_INPUT_in1t_load_reg <= '1';
          fu_INPUT_opc_reg <= dst_B1_2(0 downto 0);
          socket_INPUT_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_INPUT_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 1))) = 47 and squash_B1_1 = '0') then
          fu_INPUT_in1t_load_reg <= '1';
          fu_INPUT_opc_reg <= dst_B1_1(0 downto 0);
          socket_INPUT_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_INPUT_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 1))) = 47 and squash_B1 = '0') then
          fu_INPUT_in1t_load_reg <= '1';
          fu_INPUT_opc_reg <= dst_B1(0 downto 0);
          socket_INPUT_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_INPUT_i1_bus_cntrl_reg'length);
        else
          fu_INPUT_in1t_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 10 and squash_B1_7 = '0') then
          fu_ADDSH_1_in1t_load_reg <= '1';
          fu_ADDSH_1_opc_reg <= dst_B1_7(2 downto 0);
          socket_ADDSH_1_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_ADDSH_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 10 and squash_B1_6 = '0') then
          fu_ADDSH_1_in1t_load_reg <= '1';
          fu_ADDSH_1_opc_reg <= dst_B1_6(2 downto 0);
          socket_ADDSH_1_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_ADDSH_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 10 and squash_B1_5 = '0') then
          fu_ADDSH_1_in1t_load_reg <= '1';
          fu_ADDSH_1_opc_reg <= dst_B1_5(2 downto 0);
          socket_ADDSH_1_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_ADDSH_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 10 and squash_B1_4 = '0') then
          fu_ADDSH_1_in1t_load_reg <= '1';
          fu_ADDSH_1_opc_reg <= dst_B1_4(2 downto 0);
          socket_ADDSH_1_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_ADDSH_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 10 and squash_B1_3 = '0') then
          fu_ADDSH_1_in1t_load_reg <= '1';
          fu_ADDSH_1_opc_reg <= dst_B1_3(2 downto 0);
          socket_ADDSH_1_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_ADDSH_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 10 and squash_B1_2 = '0') then
          fu_ADDSH_1_in1t_load_reg <= '1';
          fu_ADDSH_1_opc_reg <= dst_B1_2(2 downto 0);
          socket_ADDSH_1_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_ADDSH_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 10 and squash_B1_1 = '0') then
          fu_ADDSH_1_in1t_load_reg <= '1';
          fu_ADDSH_1_opc_reg <= dst_B1_1(2 downto 0);
          socket_ADDSH_1_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_ADDSH_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 10 and squash_B1 = '0') then
          fu_ADDSH_1_in1t_load_reg <= '1';
          fu_ADDSH_1_opc_reg <= dst_B1(2 downto 0);
          socket_ADDSH_1_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_ADDSH_1_i1_bus_cntrl_reg'length);
        else
          fu_ADDSH_1_in1t_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 103 and squash_B1_7 = '0') then
          fu_ADDSH_1_in2_load_reg <= '1';
          socket_ADDSH_1_i2_bus_cntrl_reg <= conv_std_logic_vector(7, socket_ADDSH_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 103 and squash_B1_6 = '0') then
          fu_ADDSH_1_in2_load_reg <= '1';
          socket_ADDSH_1_i2_bus_cntrl_reg <= conv_std_logic_vector(6, socket_ADDSH_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 103 and squash_B1_5 = '0') then
          fu_ADDSH_1_in2_load_reg <= '1';
          socket_ADDSH_1_i2_bus_cntrl_reg <= conv_std_logic_vector(5, socket_ADDSH_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 103 and squash_B1_4 = '0') then
          fu_ADDSH_1_in2_load_reg <= '1';
          socket_ADDSH_1_i2_bus_cntrl_reg <= conv_std_logic_vector(4, socket_ADDSH_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 103 and squash_B1_3 = '0') then
          fu_ADDSH_1_in2_load_reg <= '1';
          socket_ADDSH_1_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_ADDSH_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 103 and squash_B1_2 = '0') then
          fu_ADDSH_1_in2_load_reg <= '1';
          socket_ADDSH_1_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_ADDSH_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 103 and squash_B1_1 = '0') then
          fu_ADDSH_1_in2_load_reg <= '1';
          socket_ADDSH_1_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_ADDSH_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 103 and squash_B1 = '0') then
          fu_ADDSH_1_in2_load_reg <= '1';
          socket_ADDSH_1_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_ADDSH_1_i2_bus_cntrl_reg'length);
        else
          fu_ADDSH_1_in2_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 104 and squash_B1_7 = '0') then
          fu_MUL_1_in1t_load_reg <= '1';
          socket_MUL_1_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_MUL_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 104 and squash_B1_6 = '0') then
          fu_MUL_1_in1t_load_reg <= '1';
          socket_MUL_1_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_MUL_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 104 and squash_B1_5 = '0') then
          fu_MUL_1_in1t_load_reg <= '1';
          socket_MUL_1_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_MUL_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 104 and squash_B1_4 = '0') then
          fu_MUL_1_in1t_load_reg <= '1';
          socket_MUL_1_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_MUL_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 104 and squash_B1_3 = '0') then
          fu_MUL_1_in1t_load_reg <= '1';
          socket_MUL_1_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_MUL_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 104 and squash_B1_2 = '0') then
          fu_MUL_1_in1t_load_reg <= '1';
          socket_MUL_1_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_MUL_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 104 and squash_B1_1 = '0') then
          fu_MUL_1_in1t_load_reg <= '1';
          socket_MUL_1_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_MUL_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 104 and squash_B1 = '0') then
          fu_MUL_1_in1t_load_reg <= '1';
          socket_MUL_1_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_MUL_1_i1_bus_cntrl_reg'length);
        else
          fu_MUL_1_in1t_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 105 and squash_B1_7 = '0') then
          fu_MUL_1_in2_load_reg <= '1';
          socket_MUL_1_i2_bus_cntrl_reg <= conv_std_logic_vector(7, socket_MUL_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 105 and squash_B1_6 = '0') then
          fu_MUL_1_in2_load_reg <= '1';
          socket_MUL_1_i2_bus_cntrl_reg <= conv_std_logic_vector(6, socket_MUL_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 105 and squash_B1_5 = '0') then
          fu_MUL_1_in2_load_reg <= '1';
          socket_MUL_1_i2_bus_cntrl_reg <= conv_std_logic_vector(5, socket_MUL_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 105 and squash_B1_4 = '0') then
          fu_MUL_1_in2_load_reg <= '1';
          socket_MUL_1_i2_bus_cntrl_reg <= conv_std_logic_vector(4, socket_MUL_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 105 and squash_B1_3 = '0') then
          fu_MUL_1_in2_load_reg <= '1';
          socket_MUL_1_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_MUL_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 105 and squash_B1_2 = '0') then
          fu_MUL_1_in2_load_reg <= '1';
          socket_MUL_1_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_MUL_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 105 and squash_B1_1 = '0') then
          fu_MUL_1_in2_load_reg <= '1';
          socket_MUL_1_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_MUL_1_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 105 and squash_B1 = '0') then
          fu_MUL_1_in2_load_reg <= '1';
          socket_MUL_1_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_MUL_1_i2_bus_cntrl_reg'length);
        else
          fu_MUL_1_in2_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 1))) = 45 and squash_B1_7 = '0') then
          if (conv_integer(unsigned(dst_B1_7(0 downto 0))) = 1) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_JUMP;
          elsif (conv_integer(unsigned(dst_B1_7(0 downto 0))) = 0) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_CALL;
          else
            fu_gcu_pc_load_reg <= '0';
          end if;
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 1))) = 45 and squash_B1_6 = '0') then
          if (conv_integer(unsigned(dst_B1_6(0 downto 0))) = 1) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_JUMP;
          elsif (conv_integer(unsigned(dst_B1_6(0 downto 0))) = 0) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_CALL;
          else
            fu_gcu_pc_load_reg <= '0';
          end if;
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 1))) = 45 and squash_B1_5 = '0') then
          if (conv_integer(unsigned(dst_B1_5(0 downto 0))) = 1) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_JUMP;
          elsif (conv_integer(unsigned(dst_B1_5(0 downto 0))) = 0) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_CALL;
          else
            fu_gcu_pc_load_reg <= '0';
          end if;
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 1))) = 45 and squash_B1_4 = '0') then
          if (conv_integer(unsigned(dst_B1_4(0 downto 0))) = 1) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_JUMP;
          elsif (conv_integer(unsigned(dst_B1_4(0 downto 0))) = 0) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_CALL;
          else
            fu_gcu_pc_load_reg <= '0';
          end if;
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 1))) = 45 and squash_B1_3 = '0') then
          if (conv_integer(unsigned(dst_B1_3(0 downto 0))) = 1) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_JUMP;
          elsif (conv_integer(unsigned(dst_B1_3(0 downto 0))) = 0) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_CALL;
          else
            fu_gcu_pc_load_reg <= '0';
          end if;
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 1))) = 45 and squash_B1_2 = '0') then
          if (conv_integer(unsigned(dst_B1_2(0 downto 0))) = 1) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_JUMP;
          elsif (conv_integer(unsigned(dst_B1_2(0 downto 0))) = 0) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_CALL;
          else
            fu_gcu_pc_load_reg <= '0';
          end if;
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 1))) = 45 and squash_B1_1 = '0') then
          if (conv_integer(unsigned(dst_B1_1(0 downto 0))) = 1) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_JUMP;
          elsif (conv_integer(unsigned(dst_B1_1(0 downto 0))) = 0) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_CALL;
          else
            fu_gcu_pc_load_reg <= '0';
          end if;
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 1))) = 45 and squash_B1 = '0') then
          if (conv_integer(unsigned(dst_B1(0 downto 0))) = 1) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_JUMP;
          elsif (conv_integer(unsigned(dst_B1(0 downto 0))) = 0) then
            fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= IFE_CALL;
          else
            fu_gcu_pc_load_reg <= '0';
          end if;
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_gcu_i1_bus_cntrl_reg'length);
        else
          fu_gcu_pc_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 0))) = 98 and squash_B1_7 = '0') then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(7, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 0))) = 98 and squash_B1_6 = '0') then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(6, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 0))) = 98 and squash_B1_5 = '0') then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(5, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 0))) = 98 and squash_B1_4 = '0') then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(4, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 0))) = 98 and squash_B1_3 = '0') then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 0))) = 98 and squash_B1_2 = '0') then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 0))) = 98 and squash_B1_1 = '0') then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 0))) = 98 and squash_B1 = '0') then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_gcu_i2_bus_cntrl_reg'length);
        else
          fu_gcu_ra_load_reg <= '0';
        end if;

        --control signals for RF inputs
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 3 and squash_B1_7 = '0') then
          rf_RF_0_wr_load_reg <= '1';
          rf_RF_0_wr_opc_reg <= dst_B1_7(2 downto 0);
          socket_RF_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_RF_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 3 and squash_B1_6 = '0') then
          rf_RF_0_wr_load_reg <= '1';
          rf_RF_0_wr_opc_reg <= dst_B1_6(2 downto 0);
          socket_RF_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_RF_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 3 and squash_B1_5 = '0') then
          rf_RF_0_wr_load_reg <= '1';
          rf_RF_0_wr_opc_reg <= dst_B1_5(2 downto 0);
          socket_RF_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_RF_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 3 and squash_B1_4 = '0') then
          rf_RF_0_wr_load_reg <= '1';
          rf_RF_0_wr_opc_reg <= dst_B1_4(2 downto 0);
          socket_RF_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_RF_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 3 and squash_B1_3 = '0') then
          rf_RF_0_wr_load_reg <= '1';
          rf_RF_0_wr_opc_reg <= dst_B1_3(2 downto 0);
          socket_RF_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_RF_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 3 and squash_B1_2 = '0') then
          rf_RF_0_wr_load_reg <= '1';
          rf_RF_0_wr_opc_reg <= dst_B1_2(2 downto 0);
          socket_RF_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_RF_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 3 and squash_B1_1 = '0') then
          rf_RF_0_wr_load_reg <= '1';
          rf_RF_0_wr_opc_reg <= dst_B1_1(2 downto 0);
          socket_RF_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_RF_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 3 and squash_B1 = '0') then
          rf_RF_0_wr_load_reg <= '1';
          rf_RF_0_wr_opc_reg <= dst_B1(2 downto 0);
          socket_RF_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_RF_i1_bus_cntrl_reg'length);
        else
          rf_RF_0_wr_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 1))) = 44 and squash_B1_7 = '0') then
          rf_BOOL_wr_load_reg <= '1';
          rf_BOOL_wr_opc_reg <= dst_B1_7(0 downto 0);
          socket_bool_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_bool_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 1))) = 44 and squash_B1_6 = '0') then
          rf_BOOL_wr_load_reg <= '1';
          rf_BOOL_wr_opc_reg <= dst_B1_6(0 downto 0);
          socket_bool_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_bool_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 1))) = 44 and squash_B1_5 = '0') then
          rf_BOOL_wr_load_reg <= '1';
          rf_BOOL_wr_opc_reg <= dst_B1_5(0 downto 0);
          socket_bool_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_bool_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 1))) = 44 and squash_B1_4 = '0') then
          rf_BOOL_wr_load_reg <= '1';
          rf_BOOL_wr_opc_reg <= dst_B1_4(0 downto 0);
          socket_bool_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_bool_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 1))) = 44 and squash_B1_3 = '0') then
          rf_BOOL_wr_load_reg <= '1';
          rf_BOOL_wr_opc_reg <= dst_B1_3(0 downto 0);
          socket_bool_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_bool_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 1))) = 44 and squash_B1_2 = '0') then
          rf_BOOL_wr_load_reg <= '1';
          rf_BOOL_wr_opc_reg <= dst_B1_2(0 downto 0);
          socket_bool_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_bool_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 1))) = 44 and squash_B1_1 = '0') then
          rf_BOOL_wr_load_reg <= '1';
          rf_BOOL_wr_opc_reg <= dst_B1_1(0 downto 0);
          socket_bool_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_bool_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 1))) = 44 and squash_B1 = '0') then
          rf_BOOL_wr_load_reg <= '1';
          rf_BOOL_wr_opc_reg <= dst_B1(0 downto 0);
          socket_bool_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_bool_i1_bus_cntrl_reg'length);
        else
          rf_BOOL_wr_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 5 and squash_B1_7 = '0') then
          rf_RF_1_rd_load_reg <= '1';
          rf_RF_1_rd_opc_reg <= dst_B1_7(2 downto 0);
          socket_RF_0_1_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_RF_0_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 5 and squash_B1_6 = '0') then
          rf_RF_1_rd_load_reg <= '1';
          rf_RF_1_rd_opc_reg <= dst_B1_6(2 downto 0);
          socket_RF_0_1_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_RF_0_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 5 and squash_B1_5 = '0') then
          rf_RF_1_rd_load_reg <= '1';
          rf_RF_1_rd_opc_reg <= dst_B1_5(2 downto 0);
          socket_RF_0_1_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_RF_0_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 5 and squash_B1_4 = '0') then
          rf_RF_1_rd_load_reg <= '1';
          rf_RF_1_rd_opc_reg <= dst_B1_4(2 downto 0);
          socket_RF_0_1_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_RF_0_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 5 and squash_B1_3 = '0') then
          rf_RF_1_rd_load_reg <= '1';
          rf_RF_1_rd_opc_reg <= dst_B1_3(2 downto 0);
          socket_RF_0_1_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_RF_0_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 5 and squash_B1_2 = '0') then
          rf_RF_1_rd_load_reg <= '1';
          rf_RF_1_rd_opc_reg <= dst_B1_2(2 downto 0);
          socket_RF_0_1_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_RF_0_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 5 and squash_B1_1 = '0') then
          rf_RF_1_rd_load_reg <= '1';
          rf_RF_1_rd_opc_reg <= dst_B1_1(2 downto 0);
          socket_RF_0_1_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_RF_0_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 5 and squash_B1 = '0') then
          rf_RF_1_rd_load_reg <= '1';
          rf_RF_1_rd_opc_reg <= dst_B1(2 downto 0);
          socket_RF_0_1_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_RF_0_1_i1_bus_cntrl_reg'length);
        else
          rf_RF_1_rd_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 6 and squash_B1_7 = '0') then
          rf_RF_2_rd_load_reg <= '1';
          rf_RF_2_rd_opc_reg <= dst_B1_7(2 downto 0);
          socket_RF_0_2_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_RF_0_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 6 and squash_B1_6 = '0') then
          rf_RF_2_rd_load_reg <= '1';
          rf_RF_2_rd_opc_reg <= dst_B1_6(2 downto 0);
          socket_RF_0_2_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_RF_0_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 6 and squash_B1_5 = '0') then
          rf_RF_2_rd_load_reg <= '1';
          rf_RF_2_rd_opc_reg <= dst_B1_5(2 downto 0);
          socket_RF_0_2_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_RF_0_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 6 and squash_B1_4 = '0') then
          rf_RF_2_rd_load_reg <= '1';
          rf_RF_2_rd_opc_reg <= dst_B1_4(2 downto 0);
          socket_RF_0_2_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_RF_0_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 6 and squash_B1_3 = '0') then
          rf_RF_2_rd_load_reg <= '1';
          rf_RF_2_rd_opc_reg <= dst_B1_3(2 downto 0);
          socket_RF_0_2_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_RF_0_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 6 and squash_B1_2 = '0') then
          rf_RF_2_rd_load_reg <= '1';
          rf_RF_2_rd_opc_reg <= dst_B1_2(2 downto 0);
          socket_RF_0_2_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_RF_0_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 6 and squash_B1_1 = '0') then
          rf_RF_2_rd_load_reg <= '1';
          rf_RF_2_rd_opc_reg <= dst_B1_1(2 downto 0);
          socket_RF_0_2_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_RF_0_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 6 and squash_B1 = '0') then
          rf_RF_2_rd_load_reg <= '1';
          rf_RF_2_rd_opc_reg <= dst_B1(2 downto 0);
          socket_RF_0_2_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_RF_0_2_i1_bus_cntrl_reg'length);
        else
          rf_RF_2_rd_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 7 and squash_B1_7 = '0') then
          rf_RF_3_rd_load_reg <= '1';
          rf_RF_3_rd_opc_reg <= dst_B1_7(2 downto 0);
          socket_RF_2_1_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_RF_2_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 7 and squash_B1_6 = '0') then
          rf_RF_3_rd_load_reg <= '1';
          rf_RF_3_rd_opc_reg <= dst_B1_6(2 downto 0);
          socket_RF_2_1_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_RF_2_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 7 and squash_B1_5 = '0') then
          rf_RF_3_rd_load_reg <= '1';
          rf_RF_3_rd_opc_reg <= dst_B1_5(2 downto 0);
          socket_RF_2_1_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_RF_2_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 7 and squash_B1_4 = '0') then
          rf_RF_3_rd_load_reg <= '1';
          rf_RF_3_rd_opc_reg <= dst_B1_4(2 downto 0);
          socket_RF_2_1_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_RF_2_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 7 and squash_B1_3 = '0') then
          rf_RF_3_rd_load_reg <= '1';
          rf_RF_3_rd_opc_reg <= dst_B1_3(2 downto 0);
          socket_RF_2_1_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_RF_2_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 7 and squash_B1_2 = '0') then
          rf_RF_3_rd_load_reg <= '1';
          rf_RF_3_rd_opc_reg <= dst_B1_2(2 downto 0);
          socket_RF_2_1_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_RF_2_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 7 and squash_B1_1 = '0') then
          rf_RF_3_rd_load_reg <= '1';
          rf_RF_3_rd_opc_reg <= dst_B1_1(2 downto 0);
          socket_RF_2_1_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_RF_2_1_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 7 and squash_B1 = '0') then
          rf_RF_3_rd_load_reg <= '1';
          rf_RF_3_rd_opc_reg <= dst_B1(2 downto 0);
          socket_RF_2_1_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_RF_2_1_i1_bus_cntrl_reg'length);
        else
          rf_RF_3_rd_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 8 and squash_B1_7 = '0') then
          rf_RF_4_rd_load_reg <= '1';
          rf_RF_4_rd_opc_reg <= dst_B1_7(2 downto 0);
          socket_RF_2_2_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_RF_2_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 8 and squash_B1_6 = '0') then
          rf_RF_4_rd_load_reg <= '1';
          rf_RF_4_rd_opc_reg <= dst_B1_6(2 downto 0);
          socket_RF_2_2_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_RF_2_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 8 and squash_B1_5 = '0') then
          rf_RF_4_rd_load_reg <= '1';
          rf_RF_4_rd_opc_reg <= dst_B1_5(2 downto 0);
          socket_RF_2_2_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_RF_2_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 8 and squash_B1_4 = '0') then
          rf_RF_4_rd_load_reg <= '1';
          rf_RF_4_rd_opc_reg <= dst_B1_4(2 downto 0);
          socket_RF_2_2_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_RF_2_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 8 and squash_B1_3 = '0') then
          rf_RF_4_rd_load_reg <= '1';
          rf_RF_4_rd_opc_reg <= dst_B1_3(2 downto 0);
          socket_RF_2_2_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_RF_2_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 8 and squash_B1_2 = '0') then
          rf_RF_4_rd_load_reg <= '1';
          rf_RF_4_rd_opc_reg <= dst_B1_2(2 downto 0);
          socket_RF_2_2_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_RF_2_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 8 and squash_B1_1 = '0') then
          rf_RF_4_rd_load_reg <= '1';
          rf_RF_4_rd_opc_reg <= dst_B1_1(2 downto 0);
          socket_RF_2_2_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_RF_2_2_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 8 and squash_B1 = '0') then
          rf_RF_4_rd_load_reg <= '1';
          rf_RF_4_rd_opc_reg <= dst_B1(2 downto 0);
          socket_RF_2_2_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_RF_2_2_i1_bus_cntrl_reg'length);
        else
          rf_RF_4_rd_load_reg <= '0';
        end if;
        if (conv_integer(unsigned(dst_B1_7(6 downto 3))) = 9 and squash_B1_7 = '0') then
          rf_RF_5_rd_load_reg <= '1';
          rf_RF_5_rd_opc_reg <= dst_B1_7(2 downto 0);
          socket_RF_5_i1_bus_cntrl_reg <= conv_std_logic_vector(7, socket_RF_5_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_6(6 downto 3))) = 9 and squash_B1_6 = '0') then
          rf_RF_5_rd_load_reg <= '1';
          rf_RF_5_rd_opc_reg <= dst_B1_6(2 downto 0);
          socket_RF_5_i1_bus_cntrl_reg <= conv_std_logic_vector(6, socket_RF_5_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_5(6 downto 3))) = 9 and squash_B1_5 = '0') then
          rf_RF_5_rd_load_reg <= '1';
          rf_RF_5_rd_opc_reg <= dst_B1_5(2 downto 0);
          socket_RF_5_i1_bus_cntrl_reg <= conv_std_logic_vector(5, socket_RF_5_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_4(6 downto 3))) = 9 and squash_B1_4 = '0') then
          rf_RF_5_rd_load_reg <= '1';
          rf_RF_5_rd_opc_reg <= dst_B1_4(2 downto 0);
          socket_RF_5_i1_bus_cntrl_reg <= conv_std_logic_vector(4, socket_RF_5_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_3(6 downto 3))) = 9 and squash_B1_3 = '0') then
          rf_RF_5_rd_load_reg <= '1';
          rf_RF_5_rd_opc_reg <= dst_B1_3(2 downto 0);
          socket_RF_5_i1_bus_cntrl_reg <= conv_std_logic_vector(3, socket_RF_5_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_2(6 downto 3))) = 9 and squash_B1_2 = '0') then
          rf_RF_5_rd_load_reg <= '1';
          rf_RF_5_rd_opc_reg <= dst_B1_2(2 downto 0);
          socket_RF_5_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_RF_5_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1_1(6 downto 3))) = 9 and squash_B1_1 = '0') then
          rf_RF_5_rd_load_reg <= '1';
          rf_RF_5_rd_opc_reg <= dst_B1_1(2 downto 0);
          socket_RF_5_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_RF_5_i1_bus_cntrl_reg'length);
        elsif (conv_integer(unsigned(dst_B1(6 downto 3))) = 9 and squash_B1 = '0') then
          rf_RF_5_rd_load_reg <= '1';
          rf_RF_5_rd_opc_reg <= dst_B1(2 downto 0);
          socket_RF_5_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_RF_5_i1_bus_cntrl_reg'length);
        else
          rf_RF_5_rd_load_reg <= '0';
        end if;
      end if;
    end if;
  end process;

  lock_r <= '0';
  glock <= lock;


end rtl_andor;
