# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "D:/FPGA/display_VGA/display_VGA.runs/synth_1/.Xil/Vivado-17012-Liukun/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xc7a100tcsg324-1

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common_vhdl.tcl
    set rt::defaultWorkLibName xil_defaultlib

    # Skipping read_* RTL commands because this is post-elab optimize flow
    set rt::useElabCache true
    if {$rt::useElabCache == false} {
      rt::read_verilog -sv {
      C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv
      C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_base.sv
      C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_dpdistram.sv
      C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_dprom.sv
      C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_sdpram.sv
      C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_spram.sv
      C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_sprom.sv
      C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_tdpram.sv
    }
      rt::read_verilog {
      D:/FPGA/display_VGA/display_VGA.runs/synth_1/.Xil/Vivado-17012-Liukun/realtime/clk_VGA_stub.v
      D:/FPGA/display_VGA/display_VGA.runs/synth_1/.Xil/Vivado-17012-Liukun/realtime/shift_ram_3x3_8bits_stub.v
      D:/FPGA/display_VGA/display_VGA.runs/synth_1/.Xil/Vivado-17012-Liukun/realtime/shift_ram_3x3_1bit_stub.v
      D:/FPGA/display_VGA/display_VGA.runs/synth_1/.Xil/Vivado-17012-Liukun/realtime/Uart_VGA_ram_stub.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/delay_nclk.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/compare.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/RGB2Grey.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/headfile.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/three_fsm.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/sobel_edge_detect.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/median_filter.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/erode.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/dilate.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/Uart_receiver_1byte.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/clk_divider_precise.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/process_pic.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/scan.v
      D:/FPGA/display_VGA/display_VGA.srcs/sources_1/new/disp_VGA.v
    }
      rt::read_vhdl -lib xpm C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_VCOMP.vhd
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification true
    set rt::SDCFileList D:/FPGA/display_VGA/display_VGA.runs/synth_1/.Xil/Vivado-17012-Liukun/realtime/disp_VGA_synth.xdc
    rt::sdcChecksum
    set rt::top disp_VGA
    set rt::reportTiming false
    rt::set_parameter elaborateOnly false
    rt::set_parameter elaborateRtl false
    rt::set_parameter eliminateRedundantBitOperator true
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter ramStyle auto
    rt::set_parameter merge_flipflops true
# MODE: 
    rt::set_parameter webTalkPath {D:/FPGA/display_VGA/display_VGA.cache/wt}
    rt::set_parameter enableSplitFlowPath "D:/FPGA/display_VGA/display_VGA.runs/synth_1/.Xil/Vivado-17012-Liukun/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
      rt::run_synthesis -module $rt::top
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    rt::HARTNDb_reportJobStats "Synthesis Optimization Runtime"
    if { $rt::flowresult == 1 } { return -code error }

    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] && [info exists rt::doParallel] && $rt::doParallel} { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] && [info exists rt::doParallel] && $rt::doParallel} { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}