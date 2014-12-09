package require md5 

set di_pkg_path [file dirname [info script]]

#
#	Define Dependency Injection variables
#
namespace eval DI {

	variable components
	variable instances
	variable requires
	variable postWireConfiguration

	#
	#	Initialize the variables
	#
	proc initializeVariables {} {
		variable requires
		variable postWireConfiguration

		lappend requires
		lappend postWireConfiguration
	}

}

source "$di_pkg_path/Wiring.tcl"
source "$di_pkg_path/Query.tcl"
source "$di_pkg_path/Annotations.tcl"

# 
#	Register @Component, @Inject, @InjectList
#
Annotations::register Component DI::injectableProcessor
Annotations::register Inject DI::wireSingleProcessor
Annotations::register InjectCategory DI::wireAllProcessor
Annotations::register InjectList DI::wireTypeProcessor

#
# You'll want to run DI::prepareInstances after your code has loaded
#

DI::initializeVariables