# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AddrWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BusWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ClockHigh" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ClockLow" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ClockMed" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FPGAPins" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FPGASize" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IDROMType" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IOPorts" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IOWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "InstStride0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "InstStride1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LEDCount" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LIOWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OffsetToModules" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OffsetToPinDesc" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OneWS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PWMRefWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PortWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RegStride0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RegStride1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SepClocks" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UseIRQLogic" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UseStepGenPrescaler" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UseWatchDog" -parent ${Page_0}


}

proc update_PARAM_VALUE.AddrWidth { PARAM_VALUE.AddrWidth } {
	# Procedure called to update AddrWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AddrWidth { PARAM_VALUE.AddrWidth } {
	# Procedure called to validate AddrWidth
	return true
}

proc update_PARAM_VALUE.BusWidth { PARAM_VALUE.BusWidth } {
	# Procedure called to update BusWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BusWidth { PARAM_VALUE.BusWidth } {
	# Procedure called to validate BusWidth
	return true
}

proc update_PARAM_VALUE.ClockHigh { PARAM_VALUE.ClockHigh } {
	# Procedure called to update ClockHigh when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ClockHigh { PARAM_VALUE.ClockHigh } {
	# Procedure called to validate ClockHigh
	return true
}

proc update_PARAM_VALUE.ClockLow { PARAM_VALUE.ClockLow } {
	# Procedure called to update ClockLow when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ClockLow { PARAM_VALUE.ClockLow } {
	# Procedure called to validate ClockLow
	return true
}

proc update_PARAM_VALUE.ClockMed { PARAM_VALUE.ClockMed } {
	# Procedure called to update ClockMed when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ClockMed { PARAM_VALUE.ClockMed } {
	# Procedure called to validate ClockMed
	return true
}

proc update_PARAM_VALUE.FPGAPins { PARAM_VALUE.FPGAPins } {
	# Procedure called to update FPGAPins when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FPGAPins { PARAM_VALUE.FPGAPins } {
	# Procedure called to validate FPGAPins
	return true
}

proc update_PARAM_VALUE.FPGASize { PARAM_VALUE.FPGASize } {
	# Procedure called to update FPGASize when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FPGASize { PARAM_VALUE.FPGASize } {
	# Procedure called to validate FPGASize
	return true
}

proc update_PARAM_VALUE.IDROMType { PARAM_VALUE.IDROMType } {
	# Procedure called to update IDROMType when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IDROMType { PARAM_VALUE.IDROMType } {
	# Procedure called to validate IDROMType
	return true
}

proc update_PARAM_VALUE.IOPorts { PARAM_VALUE.IOPorts } {
	# Procedure called to update IOPorts when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IOPorts { PARAM_VALUE.IOPorts } {
	# Procedure called to validate IOPorts
	return true
}

proc update_PARAM_VALUE.IOWidth { PARAM_VALUE.IOWidth } {
	# Procedure called to update IOWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IOWidth { PARAM_VALUE.IOWidth } {
	# Procedure called to validate IOWidth
	return true
}

proc update_PARAM_VALUE.InstStride0 { PARAM_VALUE.InstStride0 } {
	# Procedure called to update InstStride0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.InstStride0 { PARAM_VALUE.InstStride0 } {
	# Procedure called to validate InstStride0
	return true
}

proc update_PARAM_VALUE.InstStride1 { PARAM_VALUE.InstStride1 } {
	# Procedure called to update InstStride1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.InstStride1 { PARAM_VALUE.InstStride1 } {
	# Procedure called to validate InstStride1
	return true
}

proc update_PARAM_VALUE.LEDCount { PARAM_VALUE.LEDCount } {
	# Procedure called to update LEDCount when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LEDCount { PARAM_VALUE.LEDCount } {
	# Procedure called to validate LEDCount
	return true
}

proc update_PARAM_VALUE.LIOWidth { PARAM_VALUE.LIOWidth } {
	# Procedure called to update LIOWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LIOWidth { PARAM_VALUE.LIOWidth } {
	# Procedure called to validate LIOWidth
	return true
}

proc update_PARAM_VALUE.OffsetToModules { PARAM_VALUE.OffsetToModules } {
	# Procedure called to update OffsetToModules when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OffsetToModules { PARAM_VALUE.OffsetToModules } {
	# Procedure called to validate OffsetToModules
	return true
}

proc update_PARAM_VALUE.OffsetToPinDesc { PARAM_VALUE.OffsetToPinDesc } {
	# Procedure called to update OffsetToPinDesc when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OffsetToPinDesc { PARAM_VALUE.OffsetToPinDesc } {
	# Procedure called to validate OffsetToPinDesc
	return true
}

proc update_PARAM_VALUE.OneWS { PARAM_VALUE.OneWS } {
	# Procedure called to update OneWS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OneWS { PARAM_VALUE.OneWS } {
	# Procedure called to validate OneWS
	return true
}

proc update_PARAM_VALUE.PWMRefWidth { PARAM_VALUE.PWMRefWidth } {
	# Procedure called to update PWMRefWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PWMRefWidth { PARAM_VALUE.PWMRefWidth } {
	# Procedure called to validate PWMRefWidth
	return true
}

proc update_PARAM_VALUE.PortWidth { PARAM_VALUE.PortWidth } {
	# Procedure called to update PortWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PortWidth { PARAM_VALUE.PortWidth } {
	# Procedure called to validate PortWidth
	return true
}

proc update_PARAM_VALUE.RegStride0 { PARAM_VALUE.RegStride0 } {
	# Procedure called to update RegStride0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RegStride0 { PARAM_VALUE.RegStride0 } {
	# Procedure called to validate RegStride0
	return true
}

proc update_PARAM_VALUE.RegStride1 { PARAM_VALUE.RegStride1 } {
	# Procedure called to update RegStride1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RegStride1 { PARAM_VALUE.RegStride1 } {
	# Procedure called to validate RegStride1
	return true
}

proc update_PARAM_VALUE.SepClocks { PARAM_VALUE.SepClocks } {
	# Procedure called to update SepClocks when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SepClocks { PARAM_VALUE.SepClocks } {
	# Procedure called to validate SepClocks
	return true
}

proc update_PARAM_VALUE.UseIRQLogic { PARAM_VALUE.UseIRQLogic } {
	# Procedure called to update UseIRQLogic when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UseIRQLogic { PARAM_VALUE.UseIRQLogic } {
	# Procedure called to validate UseIRQLogic
	return true
}

proc update_PARAM_VALUE.UseStepGenPrescaler { PARAM_VALUE.UseStepGenPrescaler } {
	# Procedure called to update UseStepGenPrescaler when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UseStepGenPrescaler { PARAM_VALUE.UseStepGenPrescaler } {
	# Procedure called to validate UseStepGenPrescaler
	return true
}

proc update_PARAM_VALUE.UseWatchDog { PARAM_VALUE.UseWatchDog } {
	# Procedure called to update UseWatchDog when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UseWatchDog { PARAM_VALUE.UseWatchDog } {
	# Procedure called to validate UseWatchDog
	return true
}


proc update_MODELPARAM_VALUE.IDROMType { MODELPARAM_VALUE.IDROMType PARAM_VALUE.IDROMType } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IDROMType}] ${MODELPARAM_VALUE.IDROMType}
}

proc update_MODELPARAM_VALUE.SepClocks { MODELPARAM_VALUE.SepClocks PARAM_VALUE.SepClocks } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SepClocks}] ${MODELPARAM_VALUE.SepClocks}
}

proc update_MODELPARAM_VALUE.OneWS { MODELPARAM_VALUE.OneWS PARAM_VALUE.OneWS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OneWS}] ${MODELPARAM_VALUE.OneWS}
}

proc update_MODELPARAM_VALUE.UseStepGenPrescaler { MODELPARAM_VALUE.UseStepGenPrescaler PARAM_VALUE.UseStepGenPrescaler } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UseStepGenPrescaler}] ${MODELPARAM_VALUE.UseStepGenPrescaler}
}

proc update_MODELPARAM_VALUE.UseIRQLogic { MODELPARAM_VALUE.UseIRQLogic PARAM_VALUE.UseIRQLogic } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UseIRQLogic}] ${MODELPARAM_VALUE.UseIRQLogic}
}

proc update_MODELPARAM_VALUE.PWMRefWidth { MODELPARAM_VALUE.PWMRefWidth PARAM_VALUE.PWMRefWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PWMRefWidth}] ${MODELPARAM_VALUE.PWMRefWidth}
}

proc update_MODELPARAM_VALUE.UseWatchDog { MODELPARAM_VALUE.UseWatchDog PARAM_VALUE.UseWatchDog } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UseWatchDog}] ${MODELPARAM_VALUE.UseWatchDog}
}

proc update_MODELPARAM_VALUE.OffsetToModules { MODELPARAM_VALUE.OffsetToModules PARAM_VALUE.OffsetToModules } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OffsetToModules}] ${MODELPARAM_VALUE.OffsetToModules}
}

proc update_MODELPARAM_VALUE.OffsetToPinDesc { MODELPARAM_VALUE.OffsetToPinDesc PARAM_VALUE.OffsetToPinDesc } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OffsetToPinDesc}] ${MODELPARAM_VALUE.OffsetToPinDesc}
}

proc update_MODELPARAM_VALUE.ClockHigh { MODELPARAM_VALUE.ClockHigh PARAM_VALUE.ClockHigh } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ClockHigh}] ${MODELPARAM_VALUE.ClockHigh}
}

proc update_MODELPARAM_VALUE.ClockMed { MODELPARAM_VALUE.ClockMed PARAM_VALUE.ClockMed } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ClockMed}] ${MODELPARAM_VALUE.ClockMed}
}

proc update_MODELPARAM_VALUE.ClockLow { MODELPARAM_VALUE.ClockLow PARAM_VALUE.ClockLow } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ClockLow}] ${MODELPARAM_VALUE.ClockLow}
}

proc update_MODELPARAM_VALUE.FPGASize { MODELPARAM_VALUE.FPGASize PARAM_VALUE.FPGASize } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FPGASize}] ${MODELPARAM_VALUE.FPGASize}
}

proc update_MODELPARAM_VALUE.FPGAPins { MODELPARAM_VALUE.FPGAPins PARAM_VALUE.FPGAPins } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FPGAPins}] ${MODELPARAM_VALUE.FPGAPins}
}

proc update_MODELPARAM_VALUE.IOPorts { MODELPARAM_VALUE.IOPorts PARAM_VALUE.IOPorts } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IOPorts}] ${MODELPARAM_VALUE.IOPorts}
}

proc update_MODELPARAM_VALUE.IOWidth { MODELPARAM_VALUE.IOWidth PARAM_VALUE.IOWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IOWidth}] ${MODELPARAM_VALUE.IOWidth}
}

proc update_MODELPARAM_VALUE.LIOWidth { MODELPARAM_VALUE.LIOWidth PARAM_VALUE.LIOWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LIOWidth}] ${MODELPARAM_VALUE.LIOWidth}
}

proc update_MODELPARAM_VALUE.PortWidth { MODELPARAM_VALUE.PortWidth PARAM_VALUE.PortWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PortWidth}] ${MODELPARAM_VALUE.PortWidth}
}

proc update_MODELPARAM_VALUE.BusWidth { MODELPARAM_VALUE.BusWidth PARAM_VALUE.BusWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BusWidth}] ${MODELPARAM_VALUE.BusWidth}
}

proc update_MODELPARAM_VALUE.AddrWidth { MODELPARAM_VALUE.AddrWidth PARAM_VALUE.AddrWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AddrWidth}] ${MODELPARAM_VALUE.AddrWidth}
}

proc update_MODELPARAM_VALUE.InstStride0 { MODELPARAM_VALUE.InstStride0 PARAM_VALUE.InstStride0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.InstStride0}] ${MODELPARAM_VALUE.InstStride0}
}

proc update_MODELPARAM_VALUE.InstStride1 { MODELPARAM_VALUE.InstStride1 PARAM_VALUE.InstStride1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.InstStride1}] ${MODELPARAM_VALUE.InstStride1}
}

proc update_MODELPARAM_VALUE.RegStride0 { MODELPARAM_VALUE.RegStride0 PARAM_VALUE.RegStride0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RegStride0}] ${MODELPARAM_VALUE.RegStride0}
}

proc update_MODELPARAM_VALUE.RegStride1 { MODELPARAM_VALUE.RegStride1 PARAM_VALUE.RegStride1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RegStride1}] ${MODELPARAM_VALUE.RegStride1}
}

proc update_MODELPARAM_VALUE.LEDCount { MODELPARAM_VALUE.LEDCount PARAM_VALUE.LEDCount } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LEDCount}] ${MODELPARAM_VALUE.LEDCount}
}

