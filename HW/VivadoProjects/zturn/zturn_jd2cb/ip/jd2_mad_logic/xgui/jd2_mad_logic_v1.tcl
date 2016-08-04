# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "NUM_IO_BITS"
  ipgui::add_param $IPINST -name "NUM_DEB_STAGES"

}

proc update_PARAM_VALUE.NUM_DEB_STAGES { PARAM_VALUE.NUM_DEB_STAGES } {
	# Procedure called to update NUM_DEB_STAGES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_DEB_STAGES { PARAM_VALUE.NUM_DEB_STAGES } {
	# Procedure called to validate NUM_DEB_STAGES
	return true
}

proc update_PARAM_VALUE.NUM_IO_BITS { PARAM_VALUE.NUM_IO_BITS } {
	# Procedure called to update NUM_IO_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_IO_BITS { PARAM_VALUE.NUM_IO_BITS } {
	# Procedure called to validate NUM_IO_BITS
	return true
}


