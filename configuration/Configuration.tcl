package require TclOO

#
#	Configuration class that is able to contain a number of
#	configuration options and is able to retrieve them specifically
#	or by category, resulting in a subset of this configuration class.
#
oo::class create Std::Configuration {

	variable lookups
	variable settings

	#
	#	Initialize data-members
	#
	constructor {{listOfPairs {}}} {
		lappend lookups ""
		set settings [Std::Map new]
		my addAll $listOfPairs
	}

	#
	#	Add a lookup
	#
	method addLookup {short} {
		if {[string range $short end end] != "."} then {
			append short .
		}
		lappend lookups $short
		puts "Now has lookup for: $lookups"
	}

	#
	#	Add one key
	#
	method add {args} { 
		if {[llength $args] == 1} then {
			my addAll {*}$args
		} else {
			lassign $args key value
			$settings put $key $value
		}
	}

	#
	#	Add a number of settings
	#
	method addAll {input} {

		if {[oo::instanceof? $input Std::Configuration]} then {
			set listOfPairs [$input toList]
		} else {
			set listOfPairs $input
		}
		$settings putAll $listOfPairs
	}

	#
	#	Get TCL representation of this list
	#
	method toList {} {
		return [$settings toList]
	}

	#
	#	Does this config contain the absolute key $key?
	#
	method contains? {key} {
		return [$settings containsKey? $key]
	}

	#
	#	Get the setting from the map
	#
	method unknown {args} {
		if {[llength $args] != 1} then {
			error "expected one parameter: <settingname>"
		}

		set searchPattern [lindex $args 0]

		# get the setting names that adhere to the searchpattern
		set listOfKeys [
				Std::f> [$settings keys] {lookups searchPattern} filter { 

					# iterate over all lookups
					foreach lookup $lookups {
						if {[string first "$lookup$searchPattern" $it] == 0} then {
							return true
						}
					}
					return false
				}
			]

		# just the one key
		if {[$listOfKeys size] == 1} then {
			return [$settings get [$listOfKeys first]]
		} elseif {[$listOfKeys size] > 1} {

			# generate a subset
			lappend subset
			foreach key [$listOfKeys toList] {
				lappend subset $key [$settings get $key]
			}

			# create a new configuration and add the current
			# search pattern as a lookup path and return the
			# new instance.
			set subConfig [Std::Configuration new $subset]
			$subConfig addLookup $searchPattern
			return $subConfig
		}

		return {}
	}

}