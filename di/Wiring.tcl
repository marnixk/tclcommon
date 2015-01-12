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
		variable requires
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
		set signatures [getSignaturesFor $instance]

		foreach signature $signatures {
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
	}

	#
	#	Get a list of valid classes for this instance
	#
	proc getObjectHierarchy {instance} {
		set instanceClass [info object class $instance]
		lappend validClasses $instanceClass
		foreach superClass [info class superclasses $instanceClass] {
			lappend validClasses $superClass
		}

		return $validClasses
	}

	#
	#  Find the signature for `instance`
	#
	proc getSignaturesFor {instance} {
		variable components

		lappend signatures

		lassign $instance i_name i_instance

		# discover class and superclasses for this instance
		set validClasses [getObjectHierarchy $i_instance]
	
		foreach component $components { 
			lassign $component category className signature
			if {[lsearch $validClasses $className] != -1} then {
				lappend signatures $signature
			}
		}

		if {[llength $signatures] == 0} then {
			return -code error "No signature found for $i_name"
		}

		return $signatures
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