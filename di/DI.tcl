package require md5 

source "../annotations/annotate.tcl"

#
#	Define Dependency Injection variables
#
namespace eval DI {

	variable components
	variable instances
	variable requires

}

source "Wiring.tcl"
source "Query.tcl"
source "Annotations.tcl"

# 
#	Register @Component, @Inject, @InjectList
#
Annotations::register Component DI::injectableProcessor
Annotations::register Inject DI::wireSingleProcessor
Annotations::register InjectCategory DI::wireAllProcessor
Annotations::register InjectList DI::wireTypeProcessor

