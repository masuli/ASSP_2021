library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tce_util.all;
use work.toplevel_globals.all;
use work.toplevel_imem_mau.all;
use work.toplevel_params.all;

entity toplevel is

  port (
    clk : in std_logic;
    rstx : in std_logic;
    busy : in std_logic;
    imem_en_x : out std_logic;
    imem_addr : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    imem_data : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
    pc_init : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    fu_LSU_dmem_data_in : in std_logic_vector(fu_LSU_dataw-1 downto 0);
    fu_LSU_dmem_data_out : out std_logic_vector(fu_LSU_dataw-1 downto 0);
    fu_LSU_dmem_addr : out std_logic_vector(fu_LSU_addrw-2-1 downto 0);
    fu_LSU_dmem_mem_en_x : out std_logic_vector(0 downto 0);
    fu_LSU_dmem_wr_en_x : out std_logic_vector(0 downto 0);
    fu_LSU_dmem_bytemask : out std_logic_vector(fu_LSU_dataw/8-1 downto 0);
    fu_OUTPUT_ext_data : out std_logic_vector(7 downto 0);
    fu_OUTPUT_ext_status : in std_logic_vector(fu_OUTPUT_statusw-1 downto 0);
    fu_OUTPUT_ext_dv : out std_logic_vector(0 downto 0);
    fu_INPUT_ext_data : in std_logic_vector(7 downto 0);
    fu_INPUT_ext_status : in std_logic_vector(fu_INPUT_statusw-1 downto 0);
    fu_INPUT_ext_rdack : out std_logic_vector(0 downto 0));

end toplevel;

architecture structural of toplevel is

  signal rf_BOOL_r1data_wire : std_logic_vector(0 downto 0);
  signal rf_BOOL_r1load_wire : std_logic;
  signal rf_BOOL_r1opcode_wire : std_logic_vector(0 downto 0);
  signal rf_BOOL_t1data_wire : std_logic_vector(0 downto 0);
  signal rf_BOOL_t1load_wire : std_logic;
  signal rf_BOOL_t1opcode_wire : std_logic_vector(0 downto 0);
  signal rf_BOOL_guard_wire : std_logic_vector(1 downto 0);
  signal rf_BOOL_glock_wire : std_logic;
  signal fu_OUTPUT_t1data_wire : std_logic_vector(7 downto 0);
  signal fu_OUTPUT_t1load_wire : std_logic;
  signal fu_OUTPUT_r1data_wire : std_logic_vector(7 downto 0);
  signal fu_OUTPUT_t1opcode_wire : std_logic_vector(0 downto 0);
  signal fu_OUTPUT_glock_wire : std_logic;
  signal rf_RF_1_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_1_r1load_wire : std_logic;
  signal rf_RF_1_r1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_1_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_1_t1load_wire : std_logic;
  signal rf_RF_1_t1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_1_guard_wire : std_logic_vector(4 downto 0);
  signal rf_RF_1_glock_wire : std_logic;
  signal fu_INPUT_t1data_wire : std_logic_vector(7 downto 0);
  signal fu_INPUT_t1load_wire : std_logic;
  signal fu_INPUT_r2data_wire : std_logic_vector(7 downto 0);
  signal fu_INPUT_r1data_wire : std_logic_vector(7 downto 0);
  signal fu_INPUT_t1opcode_wire : std_logic_vector(0 downto 0);
  signal fu_INPUT_glock_wire : std_logic;
  signal rf_RF_4_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_4_r1load_wire : std_logic;
  signal rf_RF_4_r1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_4_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_4_t1load_wire : std_logic;
  signal rf_RF_4_t1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_4_guard_wire : std_logic_vector(4 downto 0);
  signal rf_RF_4_glock_wire : std_logic;
  signal fu_MUL_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_MUL_t1load_wire : std_logic;
  signal fu_MUL_o1data_wire : std_logic_vector(31 downto 0);
  signal fu_MUL_o1load_wire : std_logic;
  signal fu_MUL_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_MUL_glock_wire : std_logic;
  signal decomp_fetch_en_wire : std_logic;
  signal decomp_lock_wire : std_logic;
  signal decomp_fetchblock_wire : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
  signal decomp_instructionword_wire : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
  signal decomp_glock_wire : std_logic;
  signal decomp_lock_r_wire : std_logic;
  signal rf_RF_3_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_3_r1load_wire : std_logic;
  signal rf_RF_3_r1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_3_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_3_t1load_wire : std_logic;
  signal rf_RF_3_t1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_3_guard_wire : std_logic_vector(4 downto 0);
  signal rf_RF_3_glock_wire : std_logic;
  signal rf_RF_2_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_2_r1load_wire : std_logic;
  signal rf_RF_2_r1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_2_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_2_t1load_wire : std_logic;
  signal rf_RF_2_t1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_2_guard_wire : std_logic_vector(4 downto 0);
  signal rf_RF_2_glock_wire : std_logic;
  signal fu_LSU_t1data_wire : std_logic_vector(7 downto 0);
  signal fu_LSU_t1load_wire : std_logic;
  signal fu_LSU_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_LSU_o1data_wire : std_logic_vector(31 downto 0);
  signal fu_LSU_o1load_wire : std_logic;
  signal fu_LSU_t1opcode_wire : std_logic_vector(2 downto 0);
  signal fu_LSU_glock_wire : std_logic;
  signal inst_fetch_ra_out_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal inst_fetch_ra_in_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal inst_fetch_pc_in_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal inst_fetch_pc_load_wire : std_logic;
  signal inst_fetch_ra_load_wire : std_logic;
  signal inst_fetch_pc_opcode_wire : std_logic_vector(0 downto 0);
  signal inst_fetch_fetch_en_wire : std_logic;
  signal inst_fetch_glock_wire : std_logic;
  signal inst_fetch_fetchblock_wire : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
  signal fu_ALU_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_ALU_t1load_wire : std_logic;
  signal fu_ALU_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_ALU_o1data_wire : std_logic_vector(31 downto 0);
  signal fu_ALU_o1load_wire : std_logic;
  signal fu_ALU_t1opcode_wire : std_logic_vector(3 downto 0);
  signal fu_ALU_glock_wire : std_logic;
  signal inst_decoder_instructionword_wire : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
  signal inst_decoder_pc_load_wire : std_logic;
  signal inst_decoder_ra_load_wire : std_logic;
  signal inst_decoder_pc_opcode_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_lock_wire : std_logic;
  signal inst_decoder_lock_r_wire : std_logic;
  signal inst_decoder_simm_B1_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_1_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_1_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_2_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_2_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_3_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_3_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_lsu_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_lsu_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_lsu_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_RF_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_RF_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_bool_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_bool_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_gcu_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_gcu_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_gcu_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_ALU_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_ALU_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_ALU_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_ADDSH_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_ADDSH_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_ADDSH_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_MUL_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_MUL_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_MUL_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_RF_0_1_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_RF_0_1_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_RF_0_2_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_RF_0_2_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_RF_2_1_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_RF_2_1_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_RF_2_2_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_RF_2_2_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_INPUT_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_INPUT_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_INPUT_o2_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_RF_5_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_socket_RF_5_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_fu_LSU_in1t_load_wire : std_logic;
  signal inst_decoder_fu_LSU_in2_load_wire : std_logic;
  signal inst_decoder_fu_LSU_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_fu_ALU_in1t_load_wire : std_logic;
  signal inst_decoder_fu_ALU_in2_load_wire : std_logic;
  signal inst_decoder_fu_ALU_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_fu_ADDSH_in1t_load_wire : std_logic;
  signal inst_decoder_fu_ADDSH_in2_load_wire : std_logic;
  signal inst_decoder_fu_ADDSH_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_fu_MUL_in1t_load_wire : std_logic;
  signal inst_decoder_fu_MUL_in2_load_wire : std_logic;
  signal inst_decoder_fu_OUTPUT_in1t_load_wire : std_logic;
  signal inst_decoder_fu_OUTPUT_opc_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_fu_INPUT_in1t_load_wire : std_logic;
  signal inst_decoder_fu_INPUT_opc_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_rf_RF_0_wr_load_wire : std_logic;
  signal inst_decoder_rf_RF_0_wr_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_0_rd_load_wire : std_logic;
  signal inst_decoder_rf_RF_0_rd_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_BOOL_wr_load_wire : std_logic;
  signal inst_decoder_rf_BOOL_wr_opc_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_rf_BOOL_rd_load_wire : std_logic;
  signal inst_decoder_rf_BOOL_rd_opc_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_rf_RF_1_wr_load_wire : std_logic;
  signal inst_decoder_rf_RF_1_wr_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_1_rd_load_wire : std_logic;
  signal inst_decoder_rf_RF_1_rd_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_2_wr_load_wire : std_logic;
  signal inst_decoder_rf_RF_2_wr_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_2_rd_load_wire : std_logic;
  signal inst_decoder_rf_RF_2_rd_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_3_wr_load_wire : std_logic;
  signal inst_decoder_rf_RF_3_wr_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_3_rd_load_wire : std_logic;
  signal inst_decoder_rf_RF_3_rd_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_4_wr_load_wire : std_logic;
  signal inst_decoder_rf_RF_4_wr_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_4_rd_load_wire : std_logic;
  signal inst_decoder_rf_RF_4_rd_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_5_wr_load_wire : std_logic;
  signal inst_decoder_rf_RF_5_wr_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF_5_rd_load_wire : std_logic;
  signal inst_decoder_rf_RF_5_rd_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_guard_BOOL_0_wire : std_logic;
  signal inst_decoder_rf_guard_BOOL_1_wire : std_logic;
  signal inst_decoder_glock_wire : std_logic;
  signal rf_RF_0_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_0_r1load_wire : std_logic;
  signal rf_RF_0_r1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_0_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_0_t1load_wire : std_logic;
  signal rf_RF_0_t1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_0_guard_wire : std_logic_vector(4 downto 0);
  signal rf_RF_0_glock_wire : std_logic;
  signal fu_ADDSH_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_ADDSH_t1load_wire : std_logic;
  signal fu_ADDSH_o1data_wire : std_logic_vector(31 downto 0);
  signal fu_ADDSH_o1load_wire : std_logic;
  signal fu_ADDSH_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_ADDSH_t1opcode_wire : std_logic_vector(2 downto 0);
  signal fu_ADDSH_glock_wire : std_logic;
  signal ic_socket_lsu_i1_data_wire : std_logic_vector(7 downto 0);
  signal ic_socket_lsu_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_lsu_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_lsu_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_lsu_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_lsu_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_RF_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_RF_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_bool_i1_data_wire : std_logic_vector(0 downto 0);
  signal ic_socket_bool_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_bool_o1_data0_wire : std_logic_vector(0 downto 0);
  signal ic_socket_bool_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_gcu_i1_data_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal ic_socket_gcu_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_gcu_i2_data_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal ic_socket_gcu_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_gcu_o1_data0_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal ic_socket_gcu_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_ALU_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ALU_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_ALU_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ALU_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_ALU_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ALU_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_ADDSH_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ADDSH_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_ADDSH_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ADDSH_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_ADDSH_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ADDSH_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_MUL_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_MUL_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_MUL_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_MUL_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_MUL_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_MUL_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_RF_0_1_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_0_1_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_RF_0_1_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_0_1_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_RF_0_2_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_0_2_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_RF_0_2_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_0_2_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_RF_2_1_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_2_1_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_RF_2_1_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_2_1_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_RF_2_2_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_2_2_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_RF_2_2_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_2_2_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_data_wire : std_logic_vector(7 downto 0);
  signal ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_data0_wire : std_logic_vector(7 downto 0);
  signal ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_INPUT_i1_data_wire : std_logic_vector(7 downto 0);
  signal ic_socket_INPUT_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_INPUT_o1_data0_wire : std_logic_vector(7 downto 0);
  signal ic_socket_INPUT_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_INPUT_o2_data0_wire : std_logic_vector(7 downto 0);
  signal ic_socket_INPUT_o2_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_RF_5_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_5_o1_bus_cntrl_wire : std_logic_vector(3 downto 0);
  signal ic_socket_RF_5_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_5_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_simm_B1_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_1_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_1_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_2_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_2_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_3_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_3_wire : std_logic_vector(0 downto 0);
  signal rf_RF_5_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_5_r1load_wire : std_logic;
  signal rf_RF_5_r1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_5_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_5_t1load_wire : std_logic;
  signal rf_RF_5_t1opcode_wire : std_logic_vector(2 downto 0);
  signal rf_RF_5_guard_wire : std_logic_vector(4 downto 0);
  signal rf_RF_5_glock_wire : std_logic;
  signal ground_signal : std_logic_vector(4 downto 0);

  component toplevel_ifetch
    port (
      clk : in std_logic;
      rstx : in std_logic;
      ra_out : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      ra_in : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      busy : in std_logic;
      imem_en_x : out std_logic;
      imem_addr : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      imem_data : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      pc_in : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      pc_load : in std_logic;
      ra_load : in std_logic;
      pc_opcode : in std_logic_vector(1-1 downto 0);
      fetch_en : in std_logic;
      glock : out std_logic;
      fetchblock : out std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      pc_init : in std_logic_vector(IMEMADDRWIDTH-1 downto 0));
  end component;

  component toplevel_decompressor
    port (
      fetch_en : out std_logic;
      lock : in std_logic;
      fetchblock : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      instructionword : out std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
      glock : out std_logic;
      lock_r : in std_logic);
  end component;

  component toplevel_decoder
    port (
      instructionword : in std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
      pc_load : out std_logic;
      ra_load : out std_logic;
      pc_opcode : out std_logic_vector(1-1 downto 0);
      lock : in std_logic;
      lock_r : out std_logic;
      clk : in std_logic;
      rstx : in std_logic;
      simm_B1 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1 : out std_logic_vector(1-1 downto 0);
      simm_B1_1 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_1 : out std_logic_vector(1-1 downto 0);
      simm_B1_2 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_2 : out std_logic_vector(1-1 downto 0);
      simm_B1_3 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_3 : out std_logic_vector(1-1 downto 0);
      socket_lsu_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_lsu_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_lsu_i2_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_RF_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_RF_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_bool_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_bool_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_gcu_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_gcu_i2_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_gcu_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_ALU_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_ALU_i2_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_ALU_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_ADDSH_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_ADDSH_i2_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_ADDSH_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_MUL_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_MUL_i2_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_MUL_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_RF_0_1_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_RF_0_1_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_RF_0_2_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_RF_0_2_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_RF_2_1_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_RF_2_1_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_RF_2_2_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_RF_2_2_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_INPUT_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_INPUT_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_INPUT_o2_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_RF_5_o1_bus_cntrl : out std_logic_vector(4-1 downto 0);
      socket_RF_5_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      fu_LSU_in1t_load : out std_logic;
      fu_LSU_in2_load : out std_logic;
      fu_LSU_opc : out std_logic_vector(3-1 downto 0);
      fu_ALU_in1t_load : out std_logic;
      fu_ALU_in2_load : out std_logic;
      fu_ALU_opc : out std_logic_vector(4-1 downto 0);
      fu_ADDSH_in1t_load : out std_logic;
      fu_ADDSH_in2_load : out std_logic;
      fu_ADDSH_opc : out std_logic_vector(3-1 downto 0);
      fu_MUL_in1t_load : out std_logic;
      fu_MUL_in2_load : out std_logic;
      fu_OUTPUT_in1t_load : out std_logic;
      fu_OUTPUT_opc : out std_logic_vector(1-1 downto 0);
      fu_INPUT_in1t_load : out std_logic;
      fu_INPUT_opc : out std_logic_vector(1-1 downto 0);
      rf_RF_0_wr_load : out std_logic;
      rf_RF_0_wr_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_0_rd_load : out std_logic;
      rf_RF_0_rd_opc : out std_logic_vector(3-1 downto 0);
      rf_BOOL_wr_load : out std_logic;
      rf_BOOL_wr_opc : out std_logic_vector(1-1 downto 0);
      rf_BOOL_rd_load : out std_logic;
      rf_BOOL_rd_opc : out std_logic_vector(1-1 downto 0);
      rf_RF_1_wr_load : out std_logic;
      rf_RF_1_wr_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_1_rd_load : out std_logic;
      rf_RF_1_rd_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_2_wr_load : out std_logic;
      rf_RF_2_wr_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_2_rd_load : out std_logic;
      rf_RF_2_rd_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_3_wr_load : out std_logic;
      rf_RF_3_wr_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_3_rd_load : out std_logic;
      rf_RF_3_rd_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_4_wr_load : out std_logic;
      rf_RF_4_wr_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_4_rd_load : out std_logic;
      rf_RF_4_rd_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_5_wr_load : out std_logic;
      rf_RF_5_wr_opc : out std_logic_vector(3-1 downto 0);
      rf_RF_5_rd_load : out std_logic;
      rf_RF_5_rd_opc : out std_logic_vector(3-1 downto 0);
      rf_guard_BOOL_0 : in std_logic;
      rf_guard_BOOL_1 : in std_logic;
      glock : out std_logic);
  end component;

  component fu_lsu_with_bytemask_always_3
    generic (
      addrw : integer;
      dataw : integer);
    port (
      t1data : in std_logic_vector(addrw-1 downto 0);
      t1load : in std_logic;
      r1data : out std_logic_vector(dataw-1 downto 0);
      o1data : in std_logic_vector(dataw-1 downto 0);
      o1load : in std_logic;
      t1opcode : in std_logic_vector(3-1 downto 0);
      dmem_data_in : in std_logic_vector(dataw-1 downto 0);
      dmem_data_out : out std_logic_vector(dataw-1 downto 0);
      dmem_addr : out std_logic_vector(addrw-2-1 downto 0);
      dmem_mem_en_x : out std_logic_vector(1-1 downto 0);
      dmem_wr_en_x : out std_logic_vector(1-1 downto 0);
      dmem_bytemask : out std_logic_vector(dataw/8-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component fu_add_and_eq_gt_gtu_ior_shl_shr_shru_sub_sxhw_sxqw_xor_always_1
    generic (
      dataw : integer;
      shiftw : integer);
    port (
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      r1data : out std_logic_vector(dataw-1 downto 0);
      o1data : in std_logic_vector(dataw-1 downto 0);
      o1load : in std_logic;
      t1opcode : in std_logic_vector(4-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component fu_add_shl_shr_shru_sub_always_1
    generic (
      dataw : integer;
      busw : integer);
    port (
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      o1data : in std_logic_vector(dataw-1 downto 0);
      o1load : in std_logic;
      r1data : out std_logic_vector(busw-1 downto 0);
      t1opcode : in std_logic_vector(3-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component fu_mul_always_2
    generic (
      dataw : integer;
      busw : integer);
    port (
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      o1data : in std_logic_vector(dataw-1 downto 0);
      o1load : in std_logic;
      r1data : out std_logic_vector(busw-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component fifo_stream_out_1
    generic (
      dataw : integer;
      busw : integer;
      statusw : integer);
    port (
      t1data : in std_logic_vector(8-1 downto 0);
      t1load : in std_logic;
      r1data : out std_logic_vector(8-1 downto 0);
      t1opcode : in std_logic_vector(1-1 downto 0);
      ext_data : out std_logic_vector(8-1 downto 0);
      ext_status : in std_logic_vector(statusw-1 downto 0);
      ext_dv : out std_logic_vector(1-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component fifo_stream_in_1
    generic (
      dataw : integer;
      busw : integer;
      statusw : integer);
    port (
      t1data : in std_logic_vector(8-1 downto 0);
      t1load : in std_logic;
      r2data : out std_logic_vector(8-1 downto 0);
      r1data : out std_logic_vector(8-1 downto 0);
      t1opcode : in std_logic_vector(1-1 downto 0);
      ext_data : in std_logic_vector(8-1 downto 0);
      ext_status : in std_logic_vector(statusw-1 downto 0);
      ext_rdack : out std_logic_vector(1-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component rf_1wr_1rd_always_1_guarded_1
    generic (
      dataw : integer;
      rf_size : integer);
    port (
      r1data : out std_logic_vector(dataw-1 downto 0);
      r1load : in std_logic;
      r1opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t1opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      guard : out std_logic_vector(rf_size-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component rf_1wr_1rd_always_1_guarded_0
    generic (
      dataw : integer;
      rf_size : integer);
    port (
      r1data : out std_logic_vector(dataw-1 downto 0);
      r1load : in std_logic;
      r1opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t1opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      guard : out std_logic_vector(rf_size-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component toplevel_interconn
    port (
      socket_lsu_i1_data : out std_logic_vector(8-1 downto 0);
      socket_lsu_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_lsu_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_lsu_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_lsu_i2_data : out std_logic_vector(32-1 downto 0);
      socket_lsu_i2_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_RF_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_RF_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_bool_i1_data : out std_logic_vector(1-1 downto 0);
      socket_bool_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_bool_o1_data0 : in std_logic_vector(1-1 downto 0);
      socket_bool_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_gcu_i1_data : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      socket_gcu_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_gcu_i2_data : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      socket_gcu_i2_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_gcu_o1_data0 : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      socket_gcu_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_ALU_i1_data : out std_logic_vector(32-1 downto 0);
      socket_ALU_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_ALU_i2_data : out std_logic_vector(32-1 downto 0);
      socket_ALU_i2_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_ALU_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_ALU_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_ADDSH_i1_data : out std_logic_vector(32-1 downto 0);
      socket_ADDSH_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_ADDSH_i2_data : out std_logic_vector(32-1 downto 0);
      socket_ADDSH_i2_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_ADDSH_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_ADDSH_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_MUL_i1_data : out std_logic_vector(32-1 downto 0);
      socket_MUL_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_MUL_i2_data : out std_logic_vector(32-1 downto 0);
      socket_MUL_i2_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_MUL_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_MUL_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_RF_0_1_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_0_1_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_RF_0_1_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_0_1_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_RF_0_2_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_0_2_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_RF_0_2_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_0_2_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_RF_2_1_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_2_1_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_RF_2_1_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_2_1_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_RF_2_2_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_2_2_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_RF_2_2_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_2_2_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_data : out std_logic_vector(8-1 downto 0);
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_data0 : in std_logic_vector(8-1 downto 0);
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_INPUT_i1_data : out std_logic_vector(8-1 downto 0);
      socket_INPUT_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_INPUT_o1_data0 : in std_logic_vector(8-1 downto 0);
      socket_INPUT_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_INPUT_o2_data0 : in std_logic_vector(8-1 downto 0);
      socket_INPUT_o2_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_RF_5_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_5_o1_bus_cntrl : in std_logic_vector(4-1 downto 0);
      socket_RF_5_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_5_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      simm_B1 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1 : in std_logic_vector(1-1 downto 0);
      simm_B1_1 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_1 : in std_logic_vector(1-1 downto 0);
      simm_B1_2 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_2 : in std_logic_vector(1-1 downto 0);
      simm_B1_3 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_3 : in std_logic_vector(1-1 downto 0));
  end component;


begin

  ic_socket_gcu_o1_data0_wire <= inst_fetch_ra_out_wire;
  inst_fetch_ra_in_wire <= ic_socket_gcu_i2_data_wire;
  inst_fetch_pc_in_wire <= ic_socket_gcu_i1_data_wire;
  inst_fetch_pc_load_wire <= inst_decoder_pc_load_wire;
  inst_fetch_ra_load_wire <= inst_decoder_ra_load_wire;
  inst_fetch_pc_opcode_wire <= inst_decoder_pc_opcode_wire;
  inst_fetch_fetch_en_wire <= decomp_fetch_en_wire;
  decomp_lock_wire <= inst_fetch_glock_wire;
  decomp_fetchblock_wire <= inst_fetch_fetchblock_wire;
  inst_decoder_instructionword_wire <= decomp_instructionword_wire;
  inst_decoder_lock_wire <= decomp_glock_wire;
  decomp_lock_r_wire <= inst_decoder_lock_r_wire;
  ic_simm_B1_wire <= inst_decoder_simm_B1_wire;
  ic_simm_cntrl_B1_wire <= inst_decoder_simm_cntrl_B1_wire;
  ic_simm_B1_1_wire <= inst_decoder_simm_B1_1_wire;
  ic_simm_cntrl_B1_1_wire <= inst_decoder_simm_cntrl_B1_1_wire;
  ic_simm_B1_2_wire <= inst_decoder_simm_B1_2_wire;
  ic_simm_cntrl_B1_2_wire <= inst_decoder_simm_cntrl_B1_2_wire;
  ic_simm_B1_3_wire <= inst_decoder_simm_B1_3_wire;
  ic_simm_cntrl_B1_3_wire <= inst_decoder_simm_cntrl_B1_3_wire;
  ic_socket_lsu_i1_bus_cntrl_wire <= inst_decoder_socket_lsu_i1_bus_cntrl_wire;
  ic_socket_lsu_o1_bus_cntrl_wire <= inst_decoder_socket_lsu_o1_bus_cntrl_wire;
  ic_socket_lsu_i2_bus_cntrl_wire <= inst_decoder_socket_lsu_i2_bus_cntrl_wire;
  ic_socket_RF_i1_bus_cntrl_wire <= inst_decoder_socket_RF_i1_bus_cntrl_wire;
  ic_socket_RF_o1_bus_cntrl_wire <= inst_decoder_socket_RF_o1_bus_cntrl_wire;
  ic_socket_bool_i1_bus_cntrl_wire <= inst_decoder_socket_bool_i1_bus_cntrl_wire;
  ic_socket_bool_o1_bus_cntrl_wire <= inst_decoder_socket_bool_o1_bus_cntrl_wire;
  ic_socket_gcu_i1_bus_cntrl_wire <= inst_decoder_socket_gcu_i1_bus_cntrl_wire;
  ic_socket_gcu_i2_bus_cntrl_wire <= inst_decoder_socket_gcu_i2_bus_cntrl_wire;
  ic_socket_gcu_o1_bus_cntrl_wire <= inst_decoder_socket_gcu_o1_bus_cntrl_wire;
  ic_socket_ALU_i1_bus_cntrl_wire <= inst_decoder_socket_ALU_i1_bus_cntrl_wire;
  ic_socket_ALU_i2_bus_cntrl_wire <= inst_decoder_socket_ALU_i2_bus_cntrl_wire;
  ic_socket_ALU_o1_bus_cntrl_wire <= inst_decoder_socket_ALU_o1_bus_cntrl_wire;
  ic_socket_ADDSH_i1_bus_cntrl_wire <= inst_decoder_socket_ADDSH_i1_bus_cntrl_wire;
  ic_socket_ADDSH_i2_bus_cntrl_wire <= inst_decoder_socket_ADDSH_i2_bus_cntrl_wire;
  ic_socket_ADDSH_o1_bus_cntrl_wire <= inst_decoder_socket_ADDSH_o1_bus_cntrl_wire;
  ic_socket_MUL_i1_bus_cntrl_wire <= inst_decoder_socket_MUL_i1_bus_cntrl_wire;
  ic_socket_MUL_i2_bus_cntrl_wire <= inst_decoder_socket_MUL_i2_bus_cntrl_wire;
  ic_socket_MUL_o1_bus_cntrl_wire <= inst_decoder_socket_MUL_o1_bus_cntrl_wire;
  ic_socket_RF_0_1_o1_bus_cntrl_wire <= inst_decoder_socket_RF_0_1_o1_bus_cntrl_wire;
  ic_socket_RF_0_1_i1_bus_cntrl_wire <= inst_decoder_socket_RF_0_1_i1_bus_cntrl_wire;
  ic_socket_RF_0_2_o1_bus_cntrl_wire <= inst_decoder_socket_RF_0_2_o1_bus_cntrl_wire;
  ic_socket_RF_0_2_i1_bus_cntrl_wire <= inst_decoder_socket_RF_0_2_i1_bus_cntrl_wire;
  ic_socket_RF_2_1_o1_bus_cntrl_wire <= inst_decoder_socket_RF_2_1_o1_bus_cntrl_wire;
  ic_socket_RF_2_1_i1_bus_cntrl_wire <= inst_decoder_socket_RF_2_1_i1_bus_cntrl_wire;
  ic_socket_RF_2_2_o1_bus_cntrl_wire <= inst_decoder_socket_RF_2_2_o1_bus_cntrl_wire;
  ic_socket_RF_2_2_i1_bus_cntrl_wire <= inst_decoder_socket_RF_2_2_i1_bus_cntrl_wire;
  ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_wire <= inst_decoder_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_wire;
  ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_wire <= inst_decoder_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_wire;
  ic_socket_INPUT_i1_bus_cntrl_wire <= inst_decoder_socket_INPUT_i1_bus_cntrl_wire;
  ic_socket_INPUT_o1_bus_cntrl_wire <= inst_decoder_socket_INPUT_o1_bus_cntrl_wire;
  ic_socket_INPUT_o2_bus_cntrl_wire <= inst_decoder_socket_INPUT_o2_bus_cntrl_wire;
  ic_socket_RF_5_o1_bus_cntrl_wire <= inst_decoder_socket_RF_5_o1_bus_cntrl_wire;
  ic_socket_RF_5_i1_bus_cntrl_wire <= inst_decoder_socket_RF_5_i1_bus_cntrl_wire;
  fu_LSU_t1load_wire <= inst_decoder_fu_LSU_in1t_load_wire;
  fu_LSU_o1load_wire <= inst_decoder_fu_LSU_in2_load_wire;
  fu_LSU_t1opcode_wire <= inst_decoder_fu_LSU_opc_wire;
  fu_ALU_t1load_wire <= inst_decoder_fu_ALU_in1t_load_wire;
  fu_ALU_o1load_wire <= inst_decoder_fu_ALU_in2_load_wire;
  fu_ALU_t1opcode_wire <= inst_decoder_fu_ALU_opc_wire;
  fu_ADDSH_t1load_wire <= inst_decoder_fu_ADDSH_in1t_load_wire;
  fu_ADDSH_o1load_wire <= inst_decoder_fu_ADDSH_in2_load_wire;
  fu_ADDSH_t1opcode_wire <= inst_decoder_fu_ADDSH_opc_wire;
  fu_MUL_t1load_wire <= inst_decoder_fu_MUL_in1t_load_wire;
  fu_MUL_o1load_wire <= inst_decoder_fu_MUL_in2_load_wire;
  fu_OUTPUT_t1load_wire <= inst_decoder_fu_OUTPUT_in1t_load_wire;
  fu_OUTPUT_t1opcode_wire <= inst_decoder_fu_OUTPUT_opc_wire;
  fu_INPUT_t1load_wire <= inst_decoder_fu_INPUT_in1t_load_wire;
  fu_INPUT_t1opcode_wire <= inst_decoder_fu_INPUT_opc_wire;
  rf_RF_0_t1load_wire <= inst_decoder_rf_RF_0_wr_load_wire;
  rf_RF_0_t1opcode_wire <= inst_decoder_rf_RF_0_wr_opc_wire;
  rf_RF_0_r1load_wire <= inst_decoder_rf_RF_0_rd_load_wire;
  rf_RF_0_r1opcode_wire <= inst_decoder_rf_RF_0_rd_opc_wire;
  rf_BOOL_t1load_wire <= inst_decoder_rf_BOOL_wr_load_wire;
  rf_BOOL_t1opcode_wire <= inst_decoder_rf_BOOL_wr_opc_wire;
  rf_BOOL_r1load_wire <= inst_decoder_rf_BOOL_rd_load_wire;
  rf_BOOL_r1opcode_wire <= inst_decoder_rf_BOOL_rd_opc_wire;
  rf_RF_1_r1load_wire <= inst_decoder_rf_RF_1_wr_load_wire;
  rf_RF_1_r1opcode_wire <= inst_decoder_rf_RF_1_wr_opc_wire;
  rf_RF_1_t1load_wire <= inst_decoder_rf_RF_1_rd_load_wire;
  rf_RF_1_t1opcode_wire <= inst_decoder_rf_RF_1_rd_opc_wire;
  rf_RF_2_r1load_wire <= inst_decoder_rf_RF_2_wr_load_wire;
  rf_RF_2_r1opcode_wire <= inst_decoder_rf_RF_2_wr_opc_wire;
  rf_RF_2_t1load_wire <= inst_decoder_rf_RF_2_rd_load_wire;
  rf_RF_2_t1opcode_wire <= inst_decoder_rf_RF_2_rd_opc_wire;
  rf_RF_3_r1load_wire <= inst_decoder_rf_RF_3_wr_load_wire;
  rf_RF_3_r1opcode_wire <= inst_decoder_rf_RF_3_wr_opc_wire;
  rf_RF_3_t1load_wire <= inst_decoder_rf_RF_3_rd_load_wire;
  rf_RF_3_t1opcode_wire <= inst_decoder_rf_RF_3_rd_opc_wire;
  rf_RF_4_r1load_wire <= inst_decoder_rf_RF_4_wr_load_wire;
  rf_RF_4_r1opcode_wire <= inst_decoder_rf_RF_4_wr_opc_wire;
  rf_RF_4_t1load_wire <= inst_decoder_rf_RF_4_rd_load_wire;
  rf_RF_4_t1opcode_wire <= inst_decoder_rf_RF_4_rd_opc_wire;
  rf_RF_5_r1load_wire <= inst_decoder_rf_RF_5_wr_load_wire;
  rf_RF_5_r1opcode_wire <= inst_decoder_rf_RF_5_wr_opc_wire;
  rf_RF_5_t1load_wire <= inst_decoder_rf_RF_5_rd_load_wire;
  rf_RF_5_t1opcode_wire <= inst_decoder_rf_RF_5_rd_opc_wire;
  inst_decoder_rf_guard_BOOL_0_wire <= rf_BOOL_guard_wire(0);
  inst_decoder_rf_guard_BOOL_1_wire <= rf_BOOL_guard_wire(1);
  fu_LSU_glock_wire <= inst_decoder_glock_wire;
  fu_ALU_glock_wire <= inst_decoder_glock_wire;
  fu_ADDSH_glock_wire <= inst_decoder_glock_wire;
  fu_MUL_glock_wire <= inst_decoder_glock_wire;
  fu_OUTPUT_glock_wire <= inst_decoder_glock_wire;
  fu_INPUT_glock_wire <= inst_decoder_glock_wire;
  rf_RF_0_glock_wire <= inst_decoder_glock_wire;
  rf_BOOL_glock_wire <= inst_decoder_glock_wire;
  rf_RF_1_glock_wire <= inst_decoder_glock_wire;
  rf_RF_2_glock_wire <= inst_decoder_glock_wire;
  rf_RF_3_glock_wire <= inst_decoder_glock_wire;
  rf_RF_4_glock_wire <= inst_decoder_glock_wire;
  rf_RF_5_glock_wire <= inst_decoder_glock_wire;
  fu_LSU_t1data_wire <= ic_socket_lsu_i1_data_wire;
  ic_socket_lsu_o1_data0_wire <= fu_LSU_r1data_wire;
  fu_LSU_o1data_wire <= ic_socket_lsu_i2_data_wire;
  fu_ALU_t1data_wire <= ic_socket_ALU_i1_data_wire;
  ic_socket_ALU_o1_data0_wire <= fu_ALU_r1data_wire;
  fu_ALU_o1data_wire <= ic_socket_ALU_i2_data_wire;
  fu_ADDSH_t1data_wire <= ic_socket_ADDSH_i1_data_wire;
  fu_ADDSH_o1data_wire <= ic_socket_ADDSH_i2_data_wire;
  ic_socket_ADDSH_o1_data0_wire <= fu_ADDSH_r1data_wire;
  fu_MUL_t1data_wire <= ic_socket_MUL_i1_data_wire;
  fu_MUL_o1data_wire <= ic_socket_MUL_i2_data_wire;
  ic_socket_MUL_o1_data0_wire <= fu_MUL_r1data_wire;
  fu_OUTPUT_t1data_wire <= ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_data_wire;
  ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_data0_wire <= fu_OUTPUT_r1data_wire;
  fu_INPUT_t1data_wire <= ic_socket_INPUT_i1_data_wire;
  ic_socket_INPUT_o1_data0_wire <= fu_INPUT_r2data_wire;
  ic_socket_INPUT_o2_data0_wire <= fu_INPUT_r1data_wire;
  ic_socket_RF_o1_data0_wire <= rf_RF_0_r1data_wire;
  rf_RF_0_t1data_wire <= ic_socket_RF_i1_data_wire;
  ic_socket_bool_o1_data0_wire <= rf_BOOL_r1data_wire;
  rf_BOOL_t1data_wire <= ic_socket_bool_i1_data_wire;
  ic_socket_RF_0_1_o1_data0_wire <= rf_RF_1_r1data_wire;
  rf_RF_1_t1data_wire <= ic_socket_RF_0_1_i1_data_wire;
  ic_socket_RF_0_2_o1_data0_wire <= rf_RF_2_r1data_wire;
  rf_RF_2_t1data_wire <= ic_socket_RF_0_2_i1_data_wire;
  ic_socket_RF_2_1_o1_data0_wire <= rf_RF_3_r1data_wire;
  rf_RF_3_t1data_wire <= ic_socket_RF_2_1_i1_data_wire;
  ic_socket_RF_2_2_o1_data0_wire <= rf_RF_4_r1data_wire;
  rf_RF_4_t1data_wire <= ic_socket_RF_2_2_i1_data_wire;
  ic_socket_RF_5_o1_data0_wire <= rf_RF_5_r1data_wire;
  rf_RF_5_t1data_wire <= ic_socket_RF_5_i1_data_wire;
  ground_signal <= (others => '0');

  inst_fetch : toplevel_ifetch
    port map (
      clk => clk,
      rstx => rstx,
      ra_out => inst_fetch_ra_out_wire,
      ra_in => inst_fetch_ra_in_wire,
      busy => busy,
      imem_en_x => imem_en_x,
      imem_addr => imem_addr,
      imem_data => imem_data,
      pc_in => inst_fetch_pc_in_wire,
      pc_load => inst_fetch_pc_load_wire,
      ra_load => inst_fetch_ra_load_wire,
      pc_opcode => inst_fetch_pc_opcode_wire,
      fetch_en => inst_fetch_fetch_en_wire,
      glock => inst_fetch_glock_wire,
      fetchblock => inst_fetch_fetchblock_wire,
      pc_init => pc_init);

  decomp : toplevel_decompressor
    port map (
      fetch_en => decomp_fetch_en_wire,
      lock => decomp_lock_wire,
      fetchblock => decomp_fetchblock_wire,
      clk => clk,
      rstx => rstx,
      instructionword => decomp_instructionword_wire,
      glock => decomp_glock_wire,
      lock_r => decomp_lock_r_wire);

  inst_decoder : toplevel_decoder
    port map (
      instructionword => inst_decoder_instructionword_wire,
      pc_load => inst_decoder_pc_load_wire,
      ra_load => inst_decoder_ra_load_wire,
      pc_opcode => inst_decoder_pc_opcode_wire,
      lock => inst_decoder_lock_wire,
      lock_r => inst_decoder_lock_r_wire,
      clk => clk,
      rstx => rstx,
      simm_B1 => inst_decoder_simm_B1_wire,
      simm_cntrl_B1 => inst_decoder_simm_cntrl_B1_wire,
      simm_B1_1 => inst_decoder_simm_B1_1_wire,
      simm_cntrl_B1_1 => inst_decoder_simm_cntrl_B1_1_wire,
      simm_B1_2 => inst_decoder_simm_B1_2_wire,
      simm_cntrl_B1_2 => inst_decoder_simm_cntrl_B1_2_wire,
      simm_B1_3 => inst_decoder_simm_B1_3_wire,
      simm_cntrl_B1_3 => inst_decoder_simm_cntrl_B1_3_wire,
      socket_lsu_i1_bus_cntrl => inst_decoder_socket_lsu_i1_bus_cntrl_wire,
      socket_lsu_o1_bus_cntrl => inst_decoder_socket_lsu_o1_bus_cntrl_wire,
      socket_lsu_i2_bus_cntrl => inst_decoder_socket_lsu_i2_bus_cntrl_wire,
      socket_RF_i1_bus_cntrl => inst_decoder_socket_RF_i1_bus_cntrl_wire,
      socket_RF_o1_bus_cntrl => inst_decoder_socket_RF_o1_bus_cntrl_wire,
      socket_bool_i1_bus_cntrl => inst_decoder_socket_bool_i1_bus_cntrl_wire,
      socket_bool_o1_bus_cntrl => inst_decoder_socket_bool_o1_bus_cntrl_wire,
      socket_gcu_i1_bus_cntrl => inst_decoder_socket_gcu_i1_bus_cntrl_wire,
      socket_gcu_i2_bus_cntrl => inst_decoder_socket_gcu_i2_bus_cntrl_wire,
      socket_gcu_o1_bus_cntrl => inst_decoder_socket_gcu_o1_bus_cntrl_wire,
      socket_ALU_i1_bus_cntrl => inst_decoder_socket_ALU_i1_bus_cntrl_wire,
      socket_ALU_i2_bus_cntrl => inst_decoder_socket_ALU_i2_bus_cntrl_wire,
      socket_ALU_o1_bus_cntrl => inst_decoder_socket_ALU_o1_bus_cntrl_wire,
      socket_ADDSH_i1_bus_cntrl => inst_decoder_socket_ADDSH_i1_bus_cntrl_wire,
      socket_ADDSH_i2_bus_cntrl => inst_decoder_socket_ADDSH_i2_bus_cntrl_wire,
      socket_ADDSH_o1_bus_cntrl => inst_decoder_socket_ADDSH_o1_bus_cntrl_wire,
      socket_MUL_i1_bus_cntrl => inst_decoder_socket_MUL_i1_bus_cntrl_wire,
      socket_MUL_i2_bus_cntrl => inst_decoder_socket_MUL_i2_bus_cntrl_wire,
      socket_MUL_o1_bus_cntrl => inst_decoder_socket_MUL_o1_bus_cntrl_wire,
      socket_RF_0_1_o1_bus_cntrl => inst_decoder_socket_RF_0_1_o1_bus_cntrl_wire,
      socket_RF_0_1_i1_bus_cntrl => inst_decoder_socket_RF_0_1_i1_bus_cntrl_wire,
      socket_RF_0_2_o1_bus_cntrl => inst_decoder_socket_RF_0_2_o1_bus_cntrl_wire,
      socket_RF_0_2_i1_bus_cntrl => inst_decoder_socket_RF_0_2_i1_bus_cntrl_wire,
      socket_RF_2_1_o1_bus_cntrl => inst_decoder_socket_RF_2_1_o1_bus_cntrl_wire,
      socket_RF_2_1_i1_bus_cntrl => inst_decoder_socket_RF_2_1_i1_bus_cntrl_wire,
      socket_RF_2_2_o1_bus_cntrl => inst_decoder_socket_RF_2_2_o1_bus_cntrl_wire,
      socket_RF_2_2_i1_bus_cntrl => inst_decoder_socket_RF_2_2_i1_bus_cntrl_wire,
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl => inst_decoder_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_wire,
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl => inst_decoder_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_wire,
      socket_INPUT_i1_bus_cntrl => inst_decoder_socket_INPUT_i1_bus_cntrl_wire,
      socket_INPUT_o1_bus_cntrl => inst_decoder_socket_INPUT_o1_bus_cntrl_wire,
      socket_INPUT_o2_bus_cntrl => inst_decoder_socket_INPUT_o2_bus_cntrl_wire,
      socket_RF_5_o1_bus_cntrl => inst_decoder_socket_RF_5_o1_bus_cntrl_wire,
      socket_RF_5_i1_bus_cntrl => inst_decoder_socket_RF_5_i1_bus_cntrl_wire,
      fu_LSU_in1t_load => inst_decoder_fu_LSU_in1t_load_wire,
      fu_LSU_in2_load => inst_decoder_fu_LSU_in2_load_wire,
      fu_LSU_opc => inst_decoder_fu_LSU_opc_wire,
      fu_ALU_in1t_load => inst_decoder_fu_ALU_in1t_load_wire,
      fu_ALU_in2_load => inst_decoder_fu_ALU_in2_load_wire,
      fu_ALU_opc => inst_decoder_fu_ALU_opc_wire,
      fu_ADDSH_in1t_load => inst_decoder_fu_ADDSH_in1t_load_wire,
      fu_ADDSH_in2_load => inst_decoder_fu_ADDSH_in2_load_wire,
      fu_ADDSH_opc => inst_decoder_fu_ADDSH_opc_wire,
      fu_MUL_in1t_load => inst_decoder_fu_MUL_in1t_load_wire,
      fu_MUL_in2_load => inst_decoder_fu_MUL_in2_load_wire,
      fu_OUTPUT_in1t_load => inst_decoder_fu_OUTPUT_in1t_load_wire,
      fu_OUTPUT_opc => inst_decoder_fu_OUTPUT_opc_wire,
      fu_INPUT_in1t_load => inst_decoder_fu_INPUT_in1t_load_wire,
      fu_INPUT_opc => inst_decoder_fu_INPUT_opc_wire,
      rf_RF_0_wr_load => inst_decoder_rf_RF_0_wr_load_wire,
      rf_RF_0_wr_opc => inst_decoder_rf_RF_0_wr_opc_wire,
      rf_RF_0_rd_load => inst_decoder_rf_RF_0_rd_load_wire,
      rf_RF_0_rd_opc => inst_decoder_rf_RF_0_rd_opc_wire,
      rf_BOOL_wr_load => inst_decoder_rf_BOOL_wr_load_wire,
      rf_BOOL_wr_opc => inst_decoder_rf_BOOL_wr_opc_wire,
      rf_BOOL_rd_load => inst_decoder_rf_BOOL_rd_load_wire,
      rf_BOOL_rd_opc => inst_decoder_rf_BOOL_rd_opc_wire,
      rf_RF_1_wr_load => inst_decoder_rf_RF_1_wr_load_wire,
      rf_RF_1_wr_opc => inst_decoder_rf_RF_1_wr_opc_wire,
      rf_RF_1_rd_load => inst_decoder_rf_RF_1_rd_load_wire,
      rf_RF_1_rd_opc => inst_decoder_rf_RF_1_rd_opc_wire,
      rf_RF_2_wr_load => inst_decoder_rf_RF_2_wr_load_wire,
      rf_RF_2_wr_opc => inst_decoder_rf_RF_2_wr_opc_wire,
      rf_RF_2_rd_load => inst_decoder_rf_RF_2_rd_load_wire,
      rf_RF_2_rd_opc => inst_decoder_rf_RF_2_rd_opc_wire,
      rf_RF_3_wr_load => inst_decoder_rf_RF_3_wr_load_wire,
      rf_RF_3_wr_opc => inst_decoder_rf_RF_3_wr_opc_wire,
      rf_RF_3_rd_load => inst_decoder_rf_RF_3_rd_load_wire,
      rf_RF_3_rd_opc => inst_decoder_rf_RF_3_rd_opc_wire,
      rf_RF_4_wr_load => inst_decoder_rf_RF_4_wr_load_wire,
      rf_RF_4_wr_opc => inst_decoder_rf_RF_4_wr_opc_wire,
      rf_RF_4_rd_load => inst_decoder_rf_RF_4_rd_load_wire,
      rf_RF_4_rd_opc => inst_decoder_rf_RF_4_rd_opc_wire,
      rf_RF_5_wr_load => inst_decoder_rf_RF_5_wr_load_wire,
      rf_RF_5_wr_opc => inst_decoder_rf_RF_5_wr_opc_wire,
      rf_RF_5_rd_load => inst_decoder_rf_RF_5_rd_load_wire,
      rf_RF_5_rd_opc => inst_decoder_rf_RF_5_rd_opc_wire,
      rf_guard_BOOL_0 => inst_decoder_rf_guard_BOOL_0_wire,
      rf_guard_BOOL_1 => inst_decoder_rf_guard_BOOL_1_wire,
      glock => inst_decoder_glock_wire);

  fu_LSU : fu_lsu_with_bytemask_always_3
    generic map (
      addrw => fu_LSU_addrw,
      dataw => fu_LSU_dataw)
    port map (
      t1data => fu_LSU_t1data_wire,
      t1load => fu_LSU_t1load_wire,
      r1data => fu_LSU_r1data_wire,
      o1data => fu_LSU_o1data_wire,
      o1load => fu_LSU_o1load_wire,
      t1opcode => fu_LSU_t1opcode_wire,
      dmem_data_in => fu_LSU_dmem_data_in,
      dmem_data_out => fu_LSU_dmem_data_out,
      dmem_addr => fu_LSU_dmem_addr,
      dmem_mem_en_x => fu_LSU_dmem_mem_en_x,
      dmem_wr_en_x => fu_LSU_dmem_wr_en_x,
      dmem_bytemask => fu_LSU_dmem_bytemask,
      clk => clk,
      rstx => rstx,
      glock => fu_LSU_glock_wire);

  fu_ALU : fu_add_and_eq_gt_gtu_ior_shl_shr_shru_sub_sxhw_sxqw_xor_always_1
    generic map (
      dataw => 32,
      shiftw => 5)
    port map (
      t1data => fu_ALU_t1data_wire,
      t1load => fu_ALU_t1load_wire,
      r1data => fu_ALU_r1data_wire,
      o1data => fu_ALU_o1data_wire,
      o1load => fu_ALU_o1load_wire,
      t1opcode => fu_ALU_t1opcode_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_ALU_glock_wire);

  fu_ADDSH : fu_add_shl_shr_shru_sub_always_1
    generic map (
      dataw => 32,
      busw => 32)
    port map (
      t1data => fu_ADDSH_t1data_wire,
      t1load => fu_ADDSH_t1load_wire,
      o1data => fu_ADDSH_o1data_wire,
      o1load => fu_ADDSH_o1load_wire,
      r1data => fu_ADDSH_r1data_wire,
      t1opcode => fu_ADDSH_t1opcode_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_ADDSH_glock_wire);

  fu_MUL : fu_mul_always_2
    generic map (
      dataw => 32,
      busw => 32)
    port map (
      t1data => fu_MUL_t1data_wire,
      t1load => fu_MUL_t1load_wire,
      o1data => fu_MUL_o1data_wire,
      o1load => fu_MUL_o1load_wire,
      r1data => fu_MUL_r1data_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_MUL_glock_wire);

  fu_OUTPUT : fifo_stream_out_1
    generic map (
      dataw => 8,
      busw => 8,
      statusw => fu_OUTPUT_statusw)
    port map (
      t1data => fu_OUTPUT_t1data_wire,
      t1load => fu_OUTPUT_t1load_wire,
      r1data => fu_OUTPUT_r1data_wire,
      t1opcode => fu_OUTPUT_t1opcode_wire,
      ext_data => fu_OUTPUT_ext_data,
      ext_status => fu_OUTPUT_ext_status,
      ext_dv => fu_OUTPUT_ext_dv,
      clk => clk,
      rstx => rstx,
      glock => fu_OUTPUT_glock_wire);

  fu_INPUT : fifo_stream_in_1
    generic map (
      dataw => 8,
      busw => 8,
      statusw => fu_INPUT_statusw)
    port map (
      t1data => fu_INPUT_t1data_wire,
      t1load => fu_INPUT_t1load_wire,
      r2data => fu_INPUT_r2data_wire,
      r1data => fu_INPUT_r1data_wire,
      t1opcode => fu_INPUT_t1opcode_wire,
      ext_data => fu_INPUT_ext_data,
      ext_status => fu_INPUT_ext_status,
      ext_rdack => fu_INPUT_ext_rdack,
      clk => clk,
      rstx => rstx,
      glock => fu_INPUT_glock_wire);

  rf_RF_0 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 5)
    port map (
      r1data => rf_RF_0_r1data_wire,
      r1load => rf_RF_0_r1load_wire,
      r1opcode => rf_RF_0_r1opcode_wire,
      t1data => rf_RF_0_t1data_wire,
      t1load => rf_RF_0_t1load_wire,
      t1opcode => rf_RF_0_t1opcode_wire,
      guard => rf_RF_0_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF_0_glock_wire);

  rf_BOOL : rf_1wr_1rd_always_1_guarded_0
    generic map (
      dataw => 1,
      rf_size => 2)
    port map (
      r1data => rf_BOOL_r1data_wire,
      r1load => rf_BOOL_r1load_wire,
      r1opcode => rf_BOOL_r1opcode_wire,
      t1data => rf_BOOL_t1data_wire,
      t1load => rf_BOOL_t1load_wire,
      t1opcode => rf_BOOL_t1opcode_wire,
      guard => rf_BOOL_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_BOOL_glock_wire);

  rf_RF_1 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 5)
    port map (
      r1data => rf_RF_1_r1data_wire,
      r1load => rf_RF_1_r1load_wire,
      r1opcode => rf_RF_1_r1opcode_wire,
      t1data => rf_RF_1_t1data_wire,
      t1load => rf_RF_1_t1load_wire,
      t1opcode => rf_RF_1_t1opcode_wire,
      guard => rf_RF_1_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF_1_glock_wire);

  rf_RF_2 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 5)
    port map (
      r1data => rf_RF_2_r1data_wire,
      r1load => rf_RF_2_r1load_wire,
      r1opcode => rf_RF_2_r1opcode_wire,
      t1data => rf_RF_2_t1data_wire,
      t1load => rf_RF_2_t1load_wire,
      t1opcode => rf_RF_2_t1opcode_wire,
      guard => rf_RF_2_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF_2_glock_wire);

  rf_RF_3 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 5)
    port map (
      r1data => rf_RF_3_r1data_wire,
      r1load => rf_RF_3_r1load_wire,
      r1opcode => rf_RF_3_r1opcode_wire,
      t1data => rf_RF_3_t1data_wire,
      t1load => rf_RF_3_t1load_wire,
      t1opcode => rf_RF_3_t1opcode_wire,
      guard => rf_RF_3_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF_3_glock_wire);

  rf_RF_4 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 5)
    port map (
      r1data => rf_RF_4_r1data_wire,
      r1load => rf_RF_4_r1load_wire,
      r1opcode => rf_RF_4_r1opcode_wire,
      t1data => rf_RF_4_t1data_wire,
      t1load => rf_RF_4_t1load_wire,
      t1opcode => rf_RF_4_t1opcode_wire,
      guard => rf_RF_4_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF_4_glock_wire);

  rf_RF_5 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 5)
    port map (
      r1data => rf_RF_5_r1data_wire,
      r1load => rf_RF_5_r1load_wire,
      r1opcode => rf_RF_5_r1opcode_wire,
      t1data => rf_RF_5_t1data_wire,
      t1load => rf_RF_5_t1load_wire,
      t1opcode => rf_RF_5_t1opcode_wire,
      guard => rf_RF_5_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF_5_glock_wire);

  ic : toplevel_interconn
    port map (
      socket_lsu_i1_data => ic_socket_lsu_i1_data_wire,
      socket_lsu_i1_bus_cntrl => ic_socket_lsu_i1_bus_cntrl_wire,
      socket_lsu_o1_data0 => ic_socket_lsu_o1_data0_wire,
      socket_lsu_o1_bus_cntrl => ic_socket_lsu_o1_bus_cntrl_wire,
      socket_lsu_i2_data => ic_socket_lsu_i2_data_wire,
      socket_lsu_i2_bus_cntrl => ic_socket_lsu_i2_bus_cntrl_wire,
      socket_RF_i1_data => ic_socket_RF_i1_data_wire,
      socket_RF_i1_bus_cntrl => ic_socket_RF_i1_bus_cntrl_wire,
      socket_RF_o1_data0 => ic_socket_RF_o1_data0_wire,
      socket_RF_o1_bus_cntrl => ic_socket_RF_o1_bus_cntrl_wire,
      socket_bool_i1_data => ic_socket_bool_i1_data_wire,
      socket_bool_i1_bus_cntrl => ic_socket_bool_i1_bus_cntrl_wire,
      socket_bool_o1_data0 => ic_socket_bool_o1_data0_wire,
      socket_bool_o1_bus_cntrl => ic_socket_bool_o1_bus_cntrl_wire,
      socket_gcu_i1_data => ic_socket_gcu_i1_data_wire,
      socket_gcu_i1_bus_cntrl => ic_socket_gcu_i1_bus_cntrl_wire,
      socket_gcu_i2_data => ic_socket_gcu_i2_data_wire,
      socket_gcu_i2_bus_cntrl => ic_socket_gcu_i2_bus_cntrl_wire,
      socket_gcu_o1_data0 => ic_socket_gcu_o1_data0_wire,
      socket_gcu_o1_bus_cntrl => ic_socket_gcu_o1_bus_cntrl_wire,
      socket_ALU_i1_data => ic_socket_ALU_i1_data_wire,
      socket_ALU_i1_bus_cntrl => ic_socket_ALU_i1_bus_cntrl_wire,
      socket_ALU_i2_data => ic_socket_ALU_i2_data_wire,
      socket_ALU_i2_bus_cntrl => ic_socket_ALU_i2_bus_cntrl_wire,
      socket_ALU_o1_data0 => ic_socket_ALU_o1_data0_wire,
      socket_ALU_o1_bus_cntrl => ic_socket_ALU_o1_bus_cntrl_wire,
      socket_ADDSH_i1_data => ic_socket_ADDSH_i1_data_wire,
      socket_ADDSH_i1_bus_cntrl => ic_socket_ADDSH_i1_bus_cntrl_wire,
      socket_ADDSH_i2_data => ic_socket_ADDSH_i2_data_wire,
      socket_ADDSH_i2_bus_cntrl => ic_socket_ADDSH_i2_bus_cntrl_wire,
      socket_ADDSH_o1_data0 => ic_socket_ADDSH_o1_data0_wire,
      socket_ADDSH_o1_bus_cntrl => ic_socket_ADDSH_o1_bus_cntrl_wire,
      socket_MUL_i1_data => ic_socket_MUL_i1_data_wire,
      socket_MUL_i1_bus_cntrl => ic_socket_MUL_i1_bus_cntrl_wire,
      socket_MUL_i2_data => ic_socket_MUL_i2_data_wire,
      socket_MUL_i2_bus_cntrl => ic_socket_MUL_i2_bus_cntrl_wire,
      socket_MUL_o1_data0 => ic_socket_MUL_o1_data0_wire,
      socket_MUL_o1_bus_cntrl => ic_socket_MUL_o1_bus_cntrl_wire,
      socket_RF_0_1_o1_data0 => ic_socket_RF_0_1_o1_data0_wire,
      socket_RF_0_1_o1_bus_cntrl => ic_socket_RF_0_1_o1_bus_cntrl_wire,
      socket_RF_0_1_i1_data => ic_socket_RF_0_1_i1_data_wire,
      socket_RF_0_1_i1_bus_cntrl => ic_socket_RF_0_1_i1_bus_cntrl_wire,
      socket_RF_0_2_o1_data0 => ic_socket_RF_0_2_o1_data0_wire,
      socket_RF_0_2_o1_bus_cntrl => ic_socket_RF_0_2_o1_bus_cntrl_wire,
      socket_RF_0_2_i1_data => ic_socket_RF_0_2_i1_data_wire,
      socket_RF_0_2_i1_bus_cntrl => ic_socket_RF_0_2_i1_bus_cntrl_wire,
      socket_RF_2_1_o1_data0 => ic_socket_RF_2_1_o1_data0_wire,
      socket_RF_2_1_o1_bus_cntrl => ic_socket_RF_2_1_o1_bus_cntrl_wire,
      socket_RF_2_1_i1_data => ic_socket_RF_2_1_i1_data_wire,
      socket_RF_2_1_i1_bus_cntrl => ic_socket_RF_2_1_i1_bus_cntrl_wire,
      socket_RF_2_2_o1_data0 => ic_socket_RF_2_2_o1_data0_wire,
      socket_RF_2_2_o1_bus_cntrl => ic_socket_RF_2_2_o1_bus_cntrl_wire,
      socket_RF_2_2_i1_data => ic_socket_RF_2_2_i1_data_wire,
      socket_RF_2_2_i1_bus_cntrl => ic_socket_RF_2_2_i1_bus_cntrl_wire,
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_data => ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_data_wire,
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl => ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_i2_bus_cntrl_wire,
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_data0 => ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_data0_wire,
      socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl => ic_socket_fifo_u8_stream_out_fifo_u8_stream_out_status_o2_bus_cntrl_wire,
      socket_INPUT_i1_data => ic_socket_INPUT_i1_data_wire,
      socket_INPUT_i1_bus_cntrl => ic_socket_INPUT_i1_bus_cntrl_wire,
      socket_INPUT_o1_data0 => ic_socket_INPUT_o1_data0_wire,
      socket_INPUT_o1_bus_cntrl => ic_socket_INPUT_o1_bus_cntrl_wire,
      socket_INPUT_o2_data0 => ic_socket_INPUT_o2_data0_wire,
      socket_INPUT_o2_bus_cntrl => ic_socket_INPUT_o2_bus_cntrl_wire,
      socket_RF_5_o1_data0 => ic_socket_RF_5_o1_data0_wire,
      socket_RF_5_o1_bus_cntrl => ic_socket_RF_5_o1_bus_cntrl_wire,
      socket_RF_5_i1_data => ic_socket_RF_5_i1_data_wire,
      socket_RF_5_i1_bus_cntrl => ic_socket_RF_5_i1_bus_cntrl_wire,
      simm_B1 => ic_simm_B1_wire,
      simm_cntrl_B1 => ic_simm_cntrl_B1_wire,
      simm_B1_1 => ic_simm_B1_1_wire,
      simm_cntrl_B1_1 => ic_simm_cntrl_B1_1_wire,
      simm_B1_2 => ic_simm_B1_2_wire,
      simm_cntrl_B1_2 => ic_simm_cntrl_B1_2_wire,
      simm_B1_3 => ic_simm_B1_3_wire,
      simm_cntrl_B1_3 => ic_simm_cntrl_B1_3_wire);

end structural;
