package require TclOO

#
#	Configuration class that is able to contain a number of
#	configuration options and is able to retrieve them specifically
#	or by category, resulting in a subset of this configuration class.
#
oo::class create Std::Configuration {

	variable settings

	constructor {{listOfPairs {}}} {
		set settings [Std::Map new]
		my addAll $listOfPairs
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
	method addAll {listOfPairs} {
		$settings putAll $listOfPairs
	}


	method toList {} {
		return [$settings toList]
	}

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
				Std::f> [$settings keys] {searchPattern} filter { 
					return [expr {[string first $searchPattern $it] == 0}]
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

			return [Std::Configuration new $subset]
		}

		return {}
	}

}