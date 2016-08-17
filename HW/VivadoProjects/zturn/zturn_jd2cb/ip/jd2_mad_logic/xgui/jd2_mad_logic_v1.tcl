# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "WIDTH"
  ipgui::add_param $IPINST -name "NUM_DEB_STAGES"

}

proc update_PARAM_VALUE.NUM_DEB_STAGES { PARAM_VALUE.NUM_DEB_STAGES } {
	# Procedure called to update NUM_DEB_STAGES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_DEB_STAGES { PARAM_VALUE.NUM_DEB_STAGES } {
	# Procedure called to validate NUM_DEB_STAGES
	return true
}

proc update_PARAM_VALUE.WIDTH { PARAM_VALUE.WIDTH } {
	# Procedure called to update WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH { PARAM_VALUE.WIDTH } {
	# Procedure called to validate WIDTH
	return true
}


proc update_MODELPARAM_VALUE.WIDTH { MODELPARAM_VALUE.WIDTH PARAM_VALUE.WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH}] ${MODELPARAM_VALUE.WIDTH}
}

proc update_MODELPARAM_VALUE.NUM_DEB_STAGES { MODELPARAM_VALUE.NUM_DEB_STAGES PARAM_VALUE.NUM_DEB_STAGES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_DEB_STAGES}] ${MODELPARAM_VALUE.NUM_DEB_STAGES}
}

