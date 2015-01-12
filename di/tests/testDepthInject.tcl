#!/usr/bin/tclsh
package require TclOO

source "../../load.tcl"

#
#	Injectable
#
@Component oo::class create Injectable {
	method print {message} {
		puts "PRINTING: $message"
	}
}

#
#	Base component
#
@Component( abstract yes ) oo::class create BaseComponent {

	@Inject( Injectable ) variable injectable

	method myMethod {} {
		$injectable print "My message"
	}

}


#
#
#
@Component oo::class create ImplComponent {
	superclass BaseComponent

	method func {} {
		puts "RUNNING"
		my myMethod
	}
}

DI::prepareInstances

set abstr [DI::get BaseComponent]
set impl [DI::get ImplComponent]
$impl func

