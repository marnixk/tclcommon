namespace eval DI {

	#
	#	Get the wired-up instance for `reqName`
	#
	proc get {reqName} {

		if {[string first "::" $reqName] != 0} then {
			set reqName "::$reqName"
		}

		variable instances
	
		# iterate over all instances
		foreach inst $instances {
			set name [lindex $inst 0]
			if {$name == $reqName} then {
				return [lindex $inst 1]
			}
		}

		error "No component with the name $reqName found"
	}

	proc getOfType {which} {
		variable components

		lappend instances
		foreach component $components {
			
			# class name
			set obj [lindex $component 1]

			# get component
			set objInst [get $obj]
			
			# is component of type `which`
			if {[info object isa typeof $objInst $which]} then {
				lappend instances [get [lindex $component 1]]
			}
		}

		return $instances
	}


	proc getInCategory {which} {
		variable components

		lappend instances
		foreach component $components {
			if {[lindex $component 0] == $which} then {
				lappend instances [get [lindex $component 1]]
			}
		}

		return $instances
	}

	
}