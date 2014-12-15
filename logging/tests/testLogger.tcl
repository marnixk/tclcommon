#!/usr/bin/tclsh

source "../../load.tcl"

set logger [Std::Logger new]
$logger debug "This is my debug message"
$logger info "This is my info message"
$logger "This is my message on the default level"


@Component oo::class create MyTestClass {

	@Inject( Std::Logger ) variable logger

	method show {} {
		$logger "The logger was wired properly"
	}
}


DI::prepareInstances
[DI::get MyTestClass] show
