namespace eval DI {

	#
	#	Add a handler that is to be executed after everything
	#	has been wired properly.
	#
	proc registerPostHandler {procName} {
		variable postWireConfiguration
		lappend postWireConfiguration $procName
	}

	#
	#	Iterate over all the components and instanciate them and hook them up properly
	#
	proc prepareInstances {} {
		variable components
		variable instances
		variable postWireConfiguration

		# instanciate all components
		foreach component $components {
			set className [lindex $component 1]

			# make sure to not instanciate abstract instances
			set abstract [lindex $component end]
			if {$abstract} {
				continue
			}

			lappend instances [list $className [$className new]]
		}

		# wire all the components together
		foreach instance $instances {
			wireInstance $instance
		}

		foreach procName $postWireConfiguration {
			$procName
		}

	}

	#
	#	Instanciate the bindings for `instance` object
	#
	proc wireInstance {instance} {
		set signature [getSignatureFor $instance]
		set requiredForInstance [getRequiredForInstance $signature] 
		
	 	set cInstance [lindex $instance 1]

		foreach requirement $requiredForInstance {
			lassign $requirement sig type which as
			
			if {$type == "single"} then {
				set ${cInstance}::$as [get $which]
			}

			if {$type == "category"} then {
				set ${cInstance}::$as [getInCategory $which]
			}

			if {$type == "oftype"} then {
				set ${cInstance}::$as [getOfType $which]
			}
		}

	}

	#
	#  Find the signature for `instance`
	#
	proc getSignatureFor {instance} {
		variable components
	
		lassign $instance i_name i_instance
		
		foreach component $components { 
			lassign $component category className signature
			if {$i_name == $className} then {
				return $signature
			}
		}

		return -code error "No signature found for $i_name"

	}

	#
	#	Get the things to hook up
	#
	proc getRequiredForInstance {signature} {
		variable requires
	
		lappend needs

		foreach req $requires {
			lassign $req r_signature type which as
			if {$signature == $r_signature} then {
				lappend needs $req
			}
		}

		return $needs
	}

}