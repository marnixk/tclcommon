package provide tclcommon 1.0

set pkg_path [file dirname [info script]]

source "$pkg_path/encapsulation/encapsulation.tcl"
source "$pkg_path/structs/struct.tcl"
source "$pkg_path/annotations/annotate.tcl"
source "$pkg_path/di/DI.tcl"
