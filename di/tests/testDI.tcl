#!/usr/bin/tclsh
package require TclOO

source "../../load.tcl"

oo::class create Endpoint {

	method run {} {
		puts "Running an endpoint"
	}

}

# Endpoint
@Component( category "endpoint" ) oo::class create EndpointA {
	superclass Endpoint

	method run {} {
		puts "Invoked through DI"
	}

}


@Component( category "endpoint" ) oo::class create EndpointB {
	superclass Endpoint
}

@Component oo::class create EndpointC {
	superclass Endpoint
}

@Component oo::class create Dispatcher {

	@Inject( EndpointA ) variable endpointA
	@InjectCategory( endpoint ) variable endpointList
	@InjectList( Endpoint ) variable all
	
	
	#
	#
	#
	method test {} {
		puts "All endpoints"
		puts $endpointList

		puts "With category `endpoint`:"
		foreach endpoint $endpointList {
			$endpoint run
		}

		puts ""
		puts "With type `Endpoint`:"
		foreach endpoint $all {
			$endpoint run
		}
	}
}

DI::prepareInstances
set di [DI::get Dispatcher]
$di test


