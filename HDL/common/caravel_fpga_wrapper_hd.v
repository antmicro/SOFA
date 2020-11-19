/*
 *-------------------------------------------------------------
 *
 * A wrapper for the FPGA IP to fit the I/O interface of Caravel SoC
 *
 * The wrapper is a technology mapped netlist where the mode-switch
 * multiplexers are mapped to the Skywater 130nm
 * High-Density (HD) standard cells
 *
 *-------------------------------------------------------------
 */

module fpga_top (
    // Fixed I/O interface from Caravel SoC definition
    // DO NOT CHANGE!!!
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oen,

    // IOs
    input  [37:0] io_in,
    output [37:0] io_out,
    output [37:0] io_oeb
);

    // Modelsim does NOT like redefining wires that already in the
    // input/output ports. The follow lines may be needed when
    // `default_nettype none
    // is enabled
    //wire [`MPRJ_IO_PADS-1:0] io_in;
    //wire [`MPRJ_IO_PADS-1:0] io_out;
    //wire [`MPRJ_IO_PADS-1:0] io_oeb;

    // FPGA wires
    wire prog_clk;
    wire Test_en;
    wire io_isol_n;
    wire clk;
    wire [0:143] gfpga_pad_EMBEDDED_IO_HD_SOC_IN;
    wire [0:143] gfpga_pad_EMBEDDED_IO_HD_SOC_OUT;
    wire [0:143] gfpga_pad_EMBEDDED_IO_HD_SOC_DIR;
    wire ccff_head;
    wire ccff_tail;
    wire sc_head;
    wire sc_tail;

    // Switch between wishbone and logic analyzer
    wire wb_la_switch;

    // Wire-bond TOP side I/O of FPGA to LEFT-side of Caravel interface
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[0] = io_in[24];
    assign io_out[24] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[0];
    assign io_oeb[24] = gfpga_pad_EMBEDDED_IO_HD_SOC_DIR[0];

    // Wire-bond TOP side I/O of FPGA to TOP-side of Caravel interface
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[1:9] = io_in[23:15];
    assign io_out[23:15] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[1:9];
    assign io_oeb[23:15] = gfpga_pad_EMBEDDED_IO_HD_SOC_DIR[1:9];

    // Wire-bond TOP side I/O of FPGA to RIGHT-side of Caravel interface
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[10:11] = io_in[14:13];
    assign io_out[14:13] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[10:11];
    assign io_oeb[14:13] = gfpga_pad_EMBEDDED_IO_HD_SOC_DIR[10:11];

    // Wire-bond RIGHT side I/O of FPGA to RIGHT-side of Caravel interface
    assign ccff_head = io_in[12];
    assign io_out[12] = 1'b0;
    assign io_oeb[12] = 1'b1;

    assign io_out[11] = sc_tail;
    assign io_oeb[11] = 1'b0;

    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[12:20] = io_in[10:2];
    assign io_out[10:2] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[12:20];
    assign io_oeb[10:2] = gfpga_pad_EMBEDDED_IO_HD_SOC_DIR[12:20];

    assign io_isol_n = io_in[1];
    assign io_out[1] = 1'b0;
    assign io_oeb[1] = 1'b1;

    assign Test_en = io_in[0];
    assign io_out[0] = 1'b0;
    assign io_oeb[0] = 1'b1;

    // Wire-bond RIGHT, BOTTOM, LEFT side I/O of FPGA to BOTTOM-side of Caravel interface
    // Autogenerate code start
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_135_MUX (.S(la_wb_switch), .A1(wb_rst_i), .A0(la_data_in[13]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[135]));
    assign la_data_out[13] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[135];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[134] = la_data_in[14];
    assign wbs_ack_o = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[134];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_133_MUX (.S(la_wb_switch), .A1(wbs_cyc_i), .A0(la_data_in[15]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[133]));
    assign la_data_out[15] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[133];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_132_MUX (.S(la_wb_switch), .A1(wbs_stb_i), .A0(la_data_in[16]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[132]));
    assign la_data_out[16] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[132];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_131_MUX (.S(la_wb_switch), .A1(wbs_we_i), .A0(la_data_in[17]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[131]));
    assign la_data_out[17] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[131];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_130_MUX (.S(la_wb_switch), .A1(wbs_sel_i[0]), .A0(la_data_in[18]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[130]));
    assign la_data_out[18] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[130];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_129_MUX (.S(la_wb_switch), .A1(wbs_sel_i[1]), .A0(la_data_in[19]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[129]));
    assign la_data_out[19] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[129];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_128_MUX (.S(la_wb_switch), .A1(wbs_sel_i[2]), .A0(la_data_in[20]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[128]));
    assign la_data_out[20] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[128];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_127_MUX (.S(la_wb_switch), .A1(wbs_sel_i[3]), .A0(la_data_in[21]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[127]));
    assign la_data_out[21] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[127];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_126_MUX (.S(la_wb_switch), .A1(wbs_adr_i[0]), .A0(la_data_in[22]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[126]));
    assign la_data_out[22] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[126];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_125_MUX (.S(la_wb_switch), .A1(wbs_adr_i[1]), .A0(la_data_in[23]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[125]));
    assign la_data_out[23] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[125];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_124_MUX (.S(la_wb_switch), .A1(wbs_adr_i[2]), .A0(la_data_in[24]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[124]));
    assign la_data_out[24] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[124];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_123_MUX (.S(la_wb_switch), .A1(wbs_adr_i[3]), .A0(la_data_in[25]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[123]));
    assign la_data_out[25] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[123];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_122_MUX (.S(la_wb_switch), .A1(wbs_adr_i[4]), .A0(la_data_in[26]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[122]));
    assign la_data_out[26] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[122];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_121_MUX (.S(la_wb_switch), .A1(wbs_adr_i[5]), .A0(la_data_in[27]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[121]));
    assign la_data_out[27] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[121];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_120_MUX (.S(la_wb_switch), .A1(wbs_adr_i[6]), .A0(la_data_in[28]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[120]));
    assign la_data_out[28] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[120];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_119_MUX (.S(la_wb_switch), .A1(wbs_adr_i[7]), .A0(la_data_in[29]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[119]));
    assign la_data_out[29] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[119];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_118_MUX (.S(la_wb_switch), .A1(wbs_adr_i[8]), .A0(la_data_in[30]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[118]));
    assign la_data_out[30] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[118];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_117_MUX (.S(la_wb_switch), .A1(wbs_adr_i[9]), .A0(la_data_in[31]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[117]));
    assign la_data_out[31] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[117];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_116_MUX (.S(la_wb_switch), .A1(wbs_adr_i[10]), .A0(la_data_in[32]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[116]));
    assign la_data_out[32] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[116];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_115_MUX (.S(la_wb_switch), .A1(wbs_adr_i[11]), .A0(la_data_in[33]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[115]));
    assign la_data_out[33] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[115];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_114_MUX (.S(la_wb_switch), .A1(wbs_adr_i[12]), .A0(la_data_in[34]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[114]));
    assign la_data_out[34] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[114];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_113_MUX (.S(la_wb_switch), .A1(wbs_adr_i[13]), .A0(la_data_in[35]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[113]));
    assign la_data_out[35] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[113];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_112_MUX (.S(la_wb_switch), .A1(wbs_adr_i[14]), .A0(la_data_in[36]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[112]));
    assign la_data_out[36] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[112];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_111_MUX (.S(la_wb_switch), .A1(wbs_adr_i[15]), .A0(la_data_in[37]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[111]));
    assign la_data_out[37] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[111];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_110_MUX (.S(la_wb_switch), .A1(wbs_adr_i[16]), .A0(la_data_in[38]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[110]));
    assign la_data_out[38] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[110];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_109_MUX (.S(la_wb_switch), .A1(wbs_adr_i[17]), .A0(la_data_in[39]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[109]));
    assign la_data_out[39] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[109];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_108_MUX (.S(la_wb_switch), .A1(wbs_adr_i[18]), .A0(la_data_in[40]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[108]));
    assign la_data_out[40] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[108];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_107_MUX (.S(la_wb_switch), .A1(wbs_adr_i[19]), .A0(la_data_in[41]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[107]));
    assign la_data_out[41] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[107];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_106_MUX (.S(la_wb_switch), .A1(wbs_adr_i[20]), .A0(la_data_in[42]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[106]));
    assign la_data_out[42] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[106];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_105_MUX (.S(la_wb_switch), .A1(wbs_adr_i[21]), .A0(la_data_in[43]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[105]));
    assign la_data_out[43] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[105];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_104_MUX (.S(la_wb_switch), .A1(wbs_adr_i[22]), .A0(la_data_in[44]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[104]));
    assign la_data_out[44] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[104];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_103_MUX (.S(la_wb_switch), .A1(wbs_adr_i[23]), .A0(la_data_in[45]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[103]));
    assign la_data_out[45] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[103];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_102_MUX (.S(la_wb_switch), .A1(wbs_adr_i[24]), .A0(la_data_in[46]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[102]));
    assign la_data_out[46] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[102];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_101_MUX (.S(la_wb_switch), .A1(wbs_adr_i[25]), .A0(la_data_in[47]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[101]));
    assign la_data_out[47] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[101];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_100_MUX (.S(la_wb_switch), .A1(wbs_adr_i[26]), .A0(la_data_in[48]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[100]));
    assign la_data_out[48] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[100];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_99_MUX (.S(la_wb_switch), .A1(wbs_adr_i[27]), .A0(la_data_in[49]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[99]));
    assign la_data_out[49] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[99];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_98_MUX (.S(la_wb_switch), .A1(wbs_adr_i[28]), .A0(la_data_in[50]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[98]));
    assign la_data_out[50] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[98];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_97_MUX (.S(la_wb_switch), .A1(wbs_adr_i[29]), .A0(la_data_in[51]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[97]));
    assign la_data_out[51] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[97];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_96_MUX (.S(la_wb_switch), .A1(wbs_adr_i[30]), .A0(la_data_in[52]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[96]));
    assign la_data_out[52] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[96];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_95_MUX (.S(la_wb_switch), .A1(wbs_adr_i[31]), .A0(la_data_in[53]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[95]));
    assign la_data_out[53] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[95];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_94_MUX (.S(la_wb_switch), .A1(wbs_dat_i[0]), .A0(la_data_in[54]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[94]));
    assign la_data_out[54] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[94];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_93_MUX (.S(la_wb_switch), .A1(wbs_dat_i[1]), .A0(la_data_in[55]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[93]));
    assign la_data_out[55] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[93];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_92_MUX (.S(la_wb_switch), .A1(wbs_dat_i[2]), .A0(la_data_in[56]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[92]));
    assign la_data_out[56] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[92];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_91_MUX (.S(la_wb_switch), .A1(wbs_dat_i[3]), .A0(la_data_in[57]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[91]));
    assign la_data_out[57] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[91];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_90_MUX (.S(la_wb_switch), .A1(wbs_dat_i[4]), .A0(la_data_in[58]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[90]));
    assign la_data_out[58] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[90];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_89_MUX (.S(la_wb_switch), .A1(wbs_dat_i[5]), .A0(la_data_in[59]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[89]));
    assign la_data_out[59] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[89];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_88_MUX (.S(la_wb_switch), .A1(wbs_dat_i[6]), .A0(la_data_in[60]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[88]));
    assign la_data_out[60] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[88];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_87_MUX (.S(la_wb_switch), .A1(wbs_dat_i[7]), .A0(la_data_in[61]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[87]));
    assign la_data_out[61] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[87];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_86_MUX (.S(la_wb_switch), .A1(wbs_dat_i[8]), .A0(la_data_in[62]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[86]));
    assign la_data_out[62] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[86];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_85_MUX (.S(la_wb_switch), .A1(wbs_dat_i[9]), .A0(la_data_in[63]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[85]));
    assign la_data_out[63] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[85];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_84_MUX (.S(la_wb_switch), .A1(wbs_dat_i[10]), .A0(la_data_in[64]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[84]));
    assign la_data_out[64] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[84];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_83_MUX (.S(la_wb_switch), .A1(wbs_dat_i[11]), .A0(la_data_in[65]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[83]));
    assign la_data_out[65] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[83];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_82_MUX (.S(la_wb_switch), .A1(wbs_dat_i[12]), .A0(la_data_in[66]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[82]));
    assign la_data_out[66] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[82];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_81_MUX (.S(la_wb_switch), .A1(wbs_dat_i[13]), .A0(la_data_in[67]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[81]));
    assign la_data_out[67] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[81];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_80_MUX (.S(la_wb_switch), .A1(wbs_dat_i[14]), .A0(la_data_in[68]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[80]));
    assign la_data_out[68] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[80];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_79_MUX (.S(la_wb_switch), .A1(wbs_dat_i[15]), .A0(la_data_in[69]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[79]));
    assign la_data_out[69] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[79];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_78_MUX (.S(la_wb_switch), .A1(wbs_dat_i[16]), .A0(la_data_in[70]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[78]));
    assign la_data_out[70] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[78];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_77_MUX (.S(la_wb_switch), .A1(wbs_dat_i[17]), .A0(la_data_in[71]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[77]));
    assign la_data_out[71] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[77];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_76_MUX (.S(la_wb_switch), .A1(wbs_dat_i[18]), .A0(la_data_in[72]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[76]));
    assign la_data_out[72] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[76];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_75_MUX (.S(la_wb_switch), .A1(wbs_dat_i[19]), .A0(la_data_in[73]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[75]));
    assign la_data_out[73] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[75];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_74_MUX (.S(la_wb_switch), .A1(wbs_dat_i[20]), .A0(la_data_in[74]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[74]));
    assign la_data_out[74] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[74];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_73_MUX (.S(la_wb_switch), .A1(wbs_dat_i[21]), .A0(la_data_in[75]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[73]));
    assign la_data_out[75] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[73];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_72_MUX (.S(la_wb_switch), .A1(wbs_dat_i[22]), .A0(la_data_in[76]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[72]));
    assign la_data_out[76] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[72];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_71_MUX (.S(la_wb_switch), .A1(wbs_dat_i[23]), .A0(la_data_in[77]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[71]));
    assign la_data_out[77] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[71];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_70_MUX (.S(la_wb_switch), .A1(wbs_dat_i[24]), .A0(la_data_in[78]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[70]));
    assign la_data_out[78] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[70];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_69_MUX (.S(la_wb_switch), .A1(wbs_dat_i[25]), .A0(la_data_in[79]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[69]));
    assign la_data_out[79] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[69];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_68_MUX (.S(la_wb_switch), .A1(wbs_dat_i[26]), .A0(la_data_in[80]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[68]));
    assign la_data_out[80] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[68];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_67_MUX (.S(la_wb_switch), .A1(wbs_dat_i[27]), .A0(la_data_in[81]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[67]));
    assign la_data_out[81] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[67];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_66_MUX (.S(la_wb_switch), .A1(wbs_dat_i[28]), .A0(la_data_in[82]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[66]));
    assign la_data_out[82] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[66];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_65_MUX (.S(la_wb_switch), .A1(wbs_dat_i[29]), .A0(la_data_in[83]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[65]));
    assign la_data_out[83] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[65];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_64_MUX (.S(la_wb_switch), .A1(wbs_dat_i[30]), .A0(la_data_in[84]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[64]));
    assign la_data_out[84] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[64];
    sky130_fd_sc_hd__mux2_1 FPGA2SOC_IN_63_MUX (.S(la_wb_switch), .A1(wbs_dat_i[31]), .A0(la_data_in[85]), .X(gfpga_pad_EMBEDDED_IO_HD_SOC_IN[63]));
    assign la_data_out[85] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[63];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[62] = la_data_in[86];
    assign wbs_dat_o[0] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[62];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[61] = la_data_in[87];
    assign wbs_dat_o[1] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[61];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[60] = la_data_in[88];
    assign wbs_dat_o[2] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[60];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[59] = la_data_in[89];
    assign wbs_dat_o[3] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[59];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[58] = la_data_in[90];
    assign wbs_dat_o[4] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[58];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[57] = la_data_in[91];
    assign wbs_dat_o[5] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[57];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[56] = la_data_in[92];
    assign wbs_dat_o[6] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[56];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[55] = la_data_in[93];
    assign wbs_dat_o[7] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[55];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[54] = la_data_in[94];
    assign wbs_dat_o[8] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[54];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[53] = la_data_in[95];
    assign wbs_dat_o[9] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[53];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[52] = la_data_in[96];
    assign wbs_dat_o[10] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[52];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[51] = la_data_in[97];
    assign wbs_dat_o[11] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[51];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[50] = la_data_in[98];
    assign wbs_dat_o[12] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[50];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[49] = la_data_in[99];
    assign wbs_dat_o[13] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[49];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[48] = la_data_in[100];
    assign wbs_dat_o[14] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[48];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[47] = la_data_in[101];
    assign wbs_dat_o[15] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[47];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[46] = la_data_in[102];
    assign wbs_dat_o[16] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[46];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[45] = la_data_in[103];
    assign wbs_dat_o[17] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[45];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[44] = la_data_in[104];
    assign wbs_dat_o[18] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[44];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[43] = la_data_in[105];
    assign wbs_dat_o[19] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[43];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[42] = la_data_in[106];
    assign wbs_dat_o[20] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[42];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[41] = la_data_in[107];
    assign wbs_dat_o[21] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[41];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[40] = la_data_in[108];
    assign wbs_dat_o[22] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[40];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[39] = la_data_in[109];
    assign wbs_dat_o[23] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[39];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[38] = la_data_in[110];
    assign wbs_dat_o[24] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[38];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[37] = la_data_in[111];
    assign wbs_dat_o[25] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[37];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[36] = la_data_in[112];
    assign wbs_dat_o[26] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[36];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[35] = la_data_in[113];
    assign wbs_dat_o[27] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[35];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[34] = la_data_in[114];
    assign wbs_dat_o[28] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[34];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[33] = la_data_in[115];
    assign wbs_dat_o[29] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[33];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[32] = la_data_in[116];
    assign wbs_dat_o[30] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[32];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[31] = la_data_in[117];
    assign wbs_dat_o[31] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[31];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[30] = la_data_in[118];
    assign la_data_out[118] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[30];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[29] = la_data_in[119];
    assign la_data_out[119] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[29];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[28] = la_data_in[120];
    assign la_data_out[120] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[28];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[27] = la_data_in[121];
    assign la_data_out[121] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[27];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[26] = la_data_in[122];
    assign la_data_out[122] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[26];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[25] = la_data_in[123];
    assign la_data_out[123] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[25];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[24] = la_data_in[124];
    assign la_data_out[124] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[24];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[23] = la_data_in[125];
    assign la_data_out[125] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[23];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[22] = la_data_in[126];
    assign la_data_out[126] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[22];
    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[21] = la_data_in[127];
    assign la_data_out[127] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[21];
    // Autogenerate code end

    // Wire-bond LEFT side I/O of FPGA to LEFT-side of Caravel interface
    assign prog_clk = io_in[37];
    assign io_out[37] = 1'b0;
    assign io_oeb[37] = 1'b1;

    // FPGA clock port can be driven by either wishbone clock or an GPIO
    sky130_fd_sc_hd__mux2_1 FPGA_CLK_MUX (.S(la_wb_switch), .A1(wb_clk_i), .A0(io_in[36]), .X(clk));
    assign io_out[36] = 1'b0;
    assign io_oeb[36] = 1'b1;

    assign io_out[35] = ccff_tail;
    assign io_oeb[35] = 1'b0;

    assign gfpga_pad_EMBEDDED_IO_HD_SOC_IN[136:143] = io_in[34:27];
    assign io_out[34:27] = gfpga_pad_EMBEDDED_IO_HD_SOC_OUT[136:143];
    assign io_oeb[34:27] = gfpga_pad_EMBEDDED_IO_HD_SOC_DIR[136:143];

    assign sc_head = io_in[26];
    assign io_out[26] = 1'b0;
    assign io_oeb[26] = 1'b1;

    // I/O[25] is reserved for a switch between wishbone interface
    // and logic analyzer
    assign wb_la_switch = io_in[25];
    assign io_out[25] = 1'b0;
    assign io_oeb[25] = 1'b1;

    // TODO: Connect spypad from FPGA to logic analyzer ports

    fpga_core fpga_core_uut(.prog_clk(prog_clk),
                        .Test_en(Test_en),
                        .clk(clk),
                        .IO_ISOL_N(io_isol_n),
                        .gfpga_pad_EMBEDDED_IO_HD_SOC_IN(gfpga_pad_EMBEDDED_IO_HD_SOC_IN),
                        .gfpga_pad_EMBEDDED_IO_HD_SOC_OUT(gfpga_pad_EMBEDDED_IO_HD_SOC_OUT),
                        .gfpga_pad_EMBEDDED_IO_HD_SOC_DIR(gfpga_pad_EMBEDDED_IO_HD_SOC_DIR),
                        .ccff_head(ccff_head),
                        .ccff_tail(ccff_tail),
                        .sc_head(sc_head),
                        .sc_tail(sc_tail)
                       );

endmodule
