namespace eval ConfigurationService {

	variable recipes
	variable config

	set config {}

	#
	#	Set the configuration base for this service.
	#
	proc setConfig {aConfig} {
		if {![oo::instanceof? $aConfig Std::Configuration]} then {
			error "Not a configuration object"
		}

		variable config
		set config $aConfig
	}

	#
	#	Register the configuration variable for hooking up later
	#
	proc registerConfigurationVariable {options args} {
		variable recipes

		if {[lindex $args 0] != "variable"} then {
			error "Expect to only wire to variables"
		}
			
		# extract useful information from current context
		set classCode [info level -3]
		set className [lindex $classCode end-1]
		set varName [lindex $args 1]
		set configBase [lindex $options 0]

		# make sure the variable is accessible
		::oo::define $className variable $varName
		
		lappend recipes [list $className $varName $configBase]
	}

	#
	#	Add all the configuration values where appropriate
	#
	proc postWireHandler {} {
		variable recipes
		variable config

		if {$config == {}} then {
			error "Invoke `ConfigurationService::setConfig` before wiring configuration instances"
		}

		# iterate over all recipes
		foreach recipe $recipes {

			# read recipes
			lassign $recipe serviceName varName base

			if {$base == {}} then {
				set configInstance $config
			} else {
				set configInstance [$config $base]
			}

			# assign instance to service
			set serviceInstance [DI::get $serviceName]
			set ${serviceInstance}::$varName $configInstance
		}
	}

}

#
#	Add the "config" annotation
#
Annotations::register Config ConfigurationService::registerConfigurationVariable

#
#	Make sure "ConfigurationService::postWireHandler" is called after DI is instantiated
#
DI::registerPostHandler ConfigurationService::postWireHandler