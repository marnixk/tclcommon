namespace eval x {

	#
	#	Encode the model into a javascript string
	#
	proc transmit {} {

		set out {}

		set nEntities [llength [entityNames]]
		set eIdx 0

		foreach name [entityNames] {
			set properties [entityProperties $name]

			set jsonProperties ""

			set nProperties [llength $properties]
			set pIdx 0
			foreach prop $properties {
				set propName [dict get $prop -property]
				set type [dict get $prop -options -type]
				set req [expr {[dict get $prop -options -required] ? "true" : "false" }]
				set multiple [expr {[dict get $prop -options -multiple] ? "true" : "false" }]

				append jsonProperties "
					\"$propName\" : {
						\"type\" : \"$type\",
						\"required\" : \"$req\",
						\"multiple\" : \"$multiple\"
					} 
				"

				incr pIdx
				if {$pIdx != $nProperties} {
					append jsonProperties ","
				}
			}

			append out "
				\"$name\" : { 
					$jsonProperties
				}
			"

			incr eIdx
			if {$eIdx != $nEntities} {
				append out ", "
			}
		}

		set wrappedOutput "{ \"entities\" : { $out } }"

		return $wrappedOutput
	}

}