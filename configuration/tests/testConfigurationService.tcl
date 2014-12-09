#!/usr/bin/tclsh

package require TclOO

source "../../load.tcl"

#
#	Wire a configuration service with the configuration object
#
@Component oo::class create TestConfigService {

	@Config variable configuration
	@Config( "ldap.header" ) variable ldap

	#
	#	Show 
	#
	method show {} {
		puts [$configuration ldap.header.id]
		puts [$ldap id]
	}
}

# load
set testdir [file dirname [info script]]
set fileConfig [Std::ConfigurationFile new "$testdir/test.properties"]

# set the configuration element
ConfigurationService::setConfig $fileConfig

# Initialize dependency-injection
DI::prepareInstances

# get the service
set s [DI::get TestConfigService]

# call the method to see if everything is hooked up
$s show
